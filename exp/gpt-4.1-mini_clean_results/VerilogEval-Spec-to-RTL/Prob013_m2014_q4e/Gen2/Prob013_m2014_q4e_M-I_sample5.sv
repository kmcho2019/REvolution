module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    nor u_nor (out, in1, in2);
endmodule