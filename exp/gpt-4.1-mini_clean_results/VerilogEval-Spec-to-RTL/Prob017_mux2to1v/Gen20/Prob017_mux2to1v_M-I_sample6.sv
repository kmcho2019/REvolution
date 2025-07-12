module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Vector-wide 2-to-1 mux: when sel=0 choose a, when sel=1 choose b
    assign out = sel ? b : a;
endmodule