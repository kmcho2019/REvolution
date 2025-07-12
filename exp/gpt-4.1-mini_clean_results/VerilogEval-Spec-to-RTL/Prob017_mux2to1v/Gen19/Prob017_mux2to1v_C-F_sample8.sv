module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Single vector 2-to-1 mux assignment optimized for synthesis
    assign out = sel ? b : a;
endmodule