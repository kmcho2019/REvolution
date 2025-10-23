module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Next-state logic for Y1 (y[1])
assign Y1 = (y[0] && w) ||  // State A with input 1
           (y[2] && ~w) || // State C with input 0
           (y[4] && w) || // State E with input 1
           (y[5] && ~w);  // State F with input 0

// Next-state logic for Y3 (y[3])
assign Y3 = (y[1] && w) ||  // State B with input 1
           (y[2] && w) ||  // State C with input 1
           (y[3]);        // State D with any input

endmodule