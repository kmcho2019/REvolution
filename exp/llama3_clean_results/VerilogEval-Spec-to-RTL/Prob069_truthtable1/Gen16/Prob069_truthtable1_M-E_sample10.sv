module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Implementing the multiplexer-based approach
assign f = (~x3 & x2) | (x3 & x1);

// Alternative implementation using a 2-to-1 multiplexer
// assign f = (x3) ? x1 : x2;

endmodule