module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Optimized implementation using a 2:1 MUX
    assign f = x3 ? x1 : x2;
endmodule