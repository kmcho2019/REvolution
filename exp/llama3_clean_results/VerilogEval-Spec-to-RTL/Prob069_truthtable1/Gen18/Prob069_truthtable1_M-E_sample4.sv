module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Use a multiplexer to select the output based on x3
assign f = (~x3) ? (x2) : (x1);

endmodule