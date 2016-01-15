'use strict';

var gulp = require('gulp');
var sass = require('gulp-sass');

gulp.task('sass', function () {
  gulp.src('./app/assets/stylesheets/spree/frontend/**/*.scss')
      .pipe(sass().on('error', sass.logError))
      .pipe(gulp.dest('./app/assets/stylesheets/spree/frontend/'));
});

gulp.task('sass:watch', function () {
  gulp.watch('./app/assets/stylesheets/spree/frontend/**/*.scss', ['sass']);
});