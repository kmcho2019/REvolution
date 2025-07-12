module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Single vectorized mux: when sel=0 choose a, else b
    assign out = sel ? b : a;
endmodule