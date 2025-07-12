module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Direct continuous assignment with ternary operator to implement 2-to-1 mux
    assign out = sel ? b : a;
endmodule