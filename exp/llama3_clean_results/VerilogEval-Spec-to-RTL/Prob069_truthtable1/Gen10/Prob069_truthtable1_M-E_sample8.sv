module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Using a 2-to-1 multiplexer to select between x2 and x1 based on x3
assign f = x3 ? x1 : x2;

endmodule