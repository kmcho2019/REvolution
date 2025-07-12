module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Direct combinational expression implementing AND with bubble on in2
    assign out = in1 & ~in2;
endmodule