module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Flat vectorized 2-to-1 mux without submodule or chunking
    assign out = sel ? b : a;
endmodule