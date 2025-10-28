const path = require("path");
const { createConfig } = require("@openedx/frontend-build");
const CopyPlugin = require("copy-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

// Create base development config
const config = createConfig("webpack-dev");

config.resolve.modules = [path.resolve(__dirname, "./src"), "node_modules"];

config.module.rules[0].exclude =
  /node_modules\/(?!(split-on-first|strict-uri-encode|@edx|mfe-extention-plugins))/;

// Override CSS handling to extract CSS files instead of inline styles
const cssRule = {
  test: /\.(css|scss|sass)$/,
  use: [
    MiniCssExtractPlugin.loader,
    {
      loader: "css-loader",
      options: {
        sourceMap: true,
        importLoaders: 2,
      },
    },
    {
      loader: "postcss-loader",
      options: {
        sourceMap: true,
      },
    },
    {
      loader: "sass-loader",
      options: {
        sourceMap: true,
        sassOptions: {
          includePaths: [
            path.join(__dirname, "node_modules"),
            path.join(__dirname, "src"),
          ],
        },
      },
    },
  ],
};

// Remove existing CSS rules and add our custom one
config.module.rules = config.module.rules.filter(
  (rule) =>
    !(
      rule.test &&
      (rule.test.toString().includes(".css") ||
        rule.test.toString().includes(".scss"))
    )
);
config.module.rules.push(cssRule);

// Add MiniCssExtractPlugin
config.plugins.push(
  new MiniCssExtractPlugin({
    filename: "static/css/[name].css",
    chunkFilename: "static/css/[name].chunk.css",
  })
);

config.plugins.push(
  new CopyPlugin({
    patterns: [
      {
        from: path.resolve(__dirname, "./public/robots.txt"),
        to: path.resolve(__dirname, "./dist/robots.txt"),
      },
    ],
  })
);

config.devServer.allowedHosts = "all";

// --- Ensure single React instance between host and linked plugin ---
config.resolve.alias = {
  ...(config.resolve.alias || {}),
  react: path.resolve(__dirname, "node_modules/react"),
  "react-dom": path.resolve(__dirname, "node_modules/react-dom"),
};

module.exports = config;
