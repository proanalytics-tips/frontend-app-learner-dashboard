import React from 'react';

import { PluginSlot } from '@openedx/frontend-plugin-framework';
import { CourseList, courseListDataShape } from 'containers/CoursesPanel/CourseList';
import { getLocale } from '@edx/frontend-platform/i18n';

export const CourseListSlot = ({ courseListData }) => {
  const locale = getLocale();
  return (
    <PluginSlot
      id="org.openedx.frontend.learner_dashboard.course_list.v1"
      idAliases={['course_list_slot']}
      pluginProps={{ courseListData, locale }}
    >
      <CourseList courseListData={courseListData} />
    </PluginSlot>
  );
};

CourseListSlot.propTypes = {
  courseListData: courseListDataShape,
};


export default CourseListSlot;
