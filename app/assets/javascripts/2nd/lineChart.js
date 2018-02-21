d3.cloudshapes.lineChartFintual = function module() {
  var margin = {top: 20, right: 20, bottom: 20, left: 80},
  width  = 300,
  height = 600;

  var data = [];
  var labels = [];
  var svg;
  var colors = d3.scale.category10().range();
  var mouseStrokeOverColor = "red";
  var dataUnit = "";
  var seriesNames = [];
  var analyticEventName = null;
  var xAxisTitle = "";
  var yAxisTitle = "";

  var ticksDivider = 1;

  var updateData;

  var tip = d3.select("body").append("div").attr("class", "chartTooltip");

  var paths = [];
  var dots = [];


  function exports(_selection) {
    _selection.each(function() {
      _data = data;

      var chartW = width - margin.left - margin.right,
      chartH = height - margin.top - margin.bottom;

      
      var y1 = d3.scale.linear()
      .domain([d3.min([d3.min(_.flatten(_data), function(d, i) { return d+d*.1; }),0]), d3.max(_.flatten(_data), function(d, i) { return d+d*.1; })]).nice(10)
      .range([chartH, 0]);
      
      var x1 = d3.scale.ordinal()
      .domain(labels.map(function(d) { return d; }))
      .rangePoints([0, chartW]);

      ticksDivider = Math.min(Math.ceil(labels.length/7), 7);

      var xAxis = d3.svg.axis()
      .scale(x1)
      .orient("bottom")
      .tickValues(_.compact(labels.map(function(d, i) {
        if(i % ticksDivider == 0) {
          return d;
        } else {
          return 0;
        }
      })));

      var yAxis = d3.svg.axis()
      .scale(y1)
      .orient("left");

      // If no SVG exists, create one - and add key groups:
      if (!svg) {
        svg = d3.select(this)
        .append("svg")
        .classed("elearn-linechart", true);
        var container = svg.append("g").classed("container-group", true);

        var legendContainer  = svg.append("g")
        .classed("legend-column", true);
      }

      container.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + (y1(0) + (margin.top)) + ")")
      .call(xAxis);

      container.append("g")
      .attr("class", "y axis")
      .attr("transform", "translate(0," + margin.top + ")")
      .call(yAxis);

      container.append("text")
      .text(yAxisTitle)
      .classed("axis-title", true)
      .attr("x", -chartH/2)
      .attr("y", -margin.left)
      .attr("text-anchor", "middle")
      .attr("dominant-baseline", "ideographic")
      .attr("transform", "rotate(-90)")
      .attr("dy", "1em");

      svg.transition().attr({width: width, height: height});
      svg.select(".container-group")
      .attr("transform", "translate(" + margin.left + ",0)");

      var line = d3.svg.line()
      .x(function(d, i) { return x1(labels[i]); })
      .y(function(d, i) { return y1(d); })
      .interpolate("monotone");

      _data.forEach(function(dataCol, i) {
        var serieContainer = container.append("g").classed("serie-container", true);

        var path = serieContainer.append("path")
        .attr("class", "line")
        .attr("d", line(dataCol))
        .attr("transform", "translate(0, " + margin.top + ")")
        .attr("fill", "none")
        .style({"stroke":colors[i], "stroke-width":"2px", "fill":"none"});

        var totalLength = path.node().getTotalLength();

        path.attr("stroke-dasharray", totalLength + " " + totalLength)
        .attr("stroke-dashoffset", totalLength)
        .transition()
        .duration(1000)
        .ease("linear")
        .attr("stroke-dashoffset", 0);


        var dot = serieContainer.selectAll(".dot")
        .data(dataCol)
        .enter().append("circle")
        .classed("dot", true)
        .attr("transform", "translate(0, " + margin.top + ")")
        .attr("r", 5)
        .attr("cx", function(d, i) { return x1(labels[i]); })
        .attr("cy", function(d) { return y1(d); })
        .on("mouseover", function(d, _i) {
          d3.select(this).style("fill", colors[i]);
          tip.style("left", d3.event.pageX+10+"px");
          tip.style("top", d3.event.pageY-25+"px");
          tip.style("display", "inline-block");
          tip.html(labels[_i] + "<br/><b>" + seriesNames[i] + "</b><br/>" + (Math.round(d*100)/100) + " " + dataUnit);
          if(analyticEventName) {
            ahoy.track(hoverEventNames['courseTimeUse']);
          }
        })
        .on("mouseout", function(d) {
          d3.select(this).style("fill", "white");
          tip.style("display", "none");
        })
        .style({"stroke":colors[i], "fill":"white"});

      });


      updateData = function() {
        _data = data;

        x1.domain(labels.map(function(d) { return d; }));
        y1.domain([0, d3.max(_.flatten(_data), function(d, i) { return d+d*.1; })]).nice(10);

        ticksDivider = Math.min(Math.ceil(labels.length/7), 7);

        xAxis.scale(x1)
        .tickValues(_.compact(labels.map(function(d, i) {
          if(i % ticksDivider == 0) {
            return d;
          } else {
            return 0;
          }
        })));

        yAxis.scale(y1);

        line.x(function(d, i) { return x1(labels[i]); })
        .y(function(d, i) { return y1(d); });

        var seriesContainers = container.selectAll('.serie-container');


        _data.forEach(function(dataCol, index) {
          var serieContainer = seriesContainers.filter(function (d, i) { return i === index;});

          serieContainer.select("path")
          .transition()
          .duration(750)
          .attr("d", line(dataCol));


          var dots = serieContainer.selectAll(".dot").data(dataCol);

          dots.exit().transition()
          .duration(750)
          .style("opacity", 0)
          .remove();

          dots.enter().append("circle")
          .classed("dot", true)
          .attr("transform", "translate(0, " + margin.top + ")")
          .attr("r", 5)
          .attr("cx", function(d, i) { return x1(labels[i]); })
          .attr("cy", function(d) { return y1(d); })
          .on("mouseover", function(d, i) {
            d3.select(this).style("fill", colors[index]);
            tip.style("left", d3.event.pageX+10+"px");
            tip.style("top", d3.event.pageY-25+"px");
            tip.style("display", "inline-block");
            tip.html(labels[i] + "<br/><b>" + seriesNames[index] + "</b><br/>" + round(d, 1).toFixed(1) + " " + dataUnit);
            if(analyticEventName) {
              ahoy.track(analyticEventName);
            }
          })
          .on("mouseout", function(d) {
            d3.select(this).style("fill", "white");
            tip.style("display", "none");
          })
          .style({"stroke":colors[index], "fill":"white"})
          .style("opacity", 0);


          dots.transition()
          .duration(750)
          .attr("cx", function(d, i) { return x1(labels[i]); })
          .attr("cy", function(d) { return y1(d); })
          .style("opacity", 1);
        });


        container.select(".x.axis")
        .transition()
        .duration(750)
        .call(xAxis);

        container.select(".y.axis")
        .transition()
        .duration(750)
        .call(yAxis);
      }

    });
  }

  exports.width = function(_x) {
    if (!arguments.length) return width;
    width = parseInt(_x);
    return this;
  };

  exports.height = function(_x) {
    if (!arguments.length) return height;
    height = parseInt(_x);
    return this;
  };

  exports.data = function(_x) {
    if (!arguments.length) return data;
    data = _x;
    if (typeof updateData === 'function') updateData();
    return this;
  };

  exports.labels = function(_x) {
    if (!arguments.length) return labels;
    labels = _x;
    return this;
  };

  exports.mouseStrokeOverColor = function(_x){
    if (!arguments.length) return mouseStrokeOverColor;
    mouseStrokeOverColor = _x;
    return this;
  }

  exports.seriesNames = function(_x) {
    if (!arguments.length) return seriesNames;
    seriesNames = _x;
    return this;
  }

  exports.colors = function(_x) {
    if (!arguments.length) return colors;
    colors = _x;
    return this;
  }

  exports.dataUnit = function(_x) {
    if (!arguments.length) return dataUnit;
    dataUnit = _x;
    return this;
  }

  exports.margin = function(_x) {
    if (!arguments.length) return margin;
    margin = _x;
    return this;
  }

  exports.analyticEventName = function(_x) {
    if (!arguments.length) return analyticEventName;
    analyticEventName = _x;
    return this;
  };

  exports.xAxisTitle = function(_x) {
    if (!arguments.length) return xAxisTitle;
    xAxisTitle = _x;
    return this;
  }

  exports.yAxisTitle = function(_x) {
    if (!arguments.length) return yAxisTitle;
    yAxisTitle = _x;
    return this;
  }

  return exports;

};
