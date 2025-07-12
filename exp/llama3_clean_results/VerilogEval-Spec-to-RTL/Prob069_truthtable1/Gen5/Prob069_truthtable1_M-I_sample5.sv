module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// The current implementation is efficient. To maintain performance and
// minimize power consumption, ensure inputs are properly buffered and
// switching activity is minimized in preceding logic stages.
assign f = (x2 & ~x3) | (x1 & x3);

endmodule