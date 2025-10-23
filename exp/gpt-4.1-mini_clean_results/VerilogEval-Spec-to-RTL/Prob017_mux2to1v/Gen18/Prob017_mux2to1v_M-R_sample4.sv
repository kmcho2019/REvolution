module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Directly assign out based on sel without any submodule
    assign out = sel ? b : a;
endmodule