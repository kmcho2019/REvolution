module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Direct 100-bit wide 2-to-1 mux using conditional operator
    assign out = sel ? b : a;
endmodule