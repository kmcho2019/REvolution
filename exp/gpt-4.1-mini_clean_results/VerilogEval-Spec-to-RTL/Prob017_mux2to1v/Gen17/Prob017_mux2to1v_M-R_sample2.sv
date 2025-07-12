module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Single continuous assignment for the 100-bit 2-to-1 mux
    assign out = sel ? b : a;
endmodule