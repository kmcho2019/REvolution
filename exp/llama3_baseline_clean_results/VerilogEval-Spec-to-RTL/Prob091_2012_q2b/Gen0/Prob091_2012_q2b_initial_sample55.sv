module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Next-state logic for y[1]
assign Y1 = (y[1] &&!w) || // State B with w = 0
           (y[5] && w) ||  // State F with w = 1
           (y[4] &&!w) || // State E with w = 0
           (y[3] && w);    // State D with w = 1

// Next-state logic for y[3]
assign Y3 = (y[2] &&!w) || // State C with w = 0
           (y[1] && w) ||  // State B with w = 1
           (y[3] &&!w);    // State D with w = 0

endmodule