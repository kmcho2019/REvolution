module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Vectorized 2-to-1 mux using bitwise operations
    assign out = (~{100{sel}} & a) | ({100{sel}} & b);
endmodule