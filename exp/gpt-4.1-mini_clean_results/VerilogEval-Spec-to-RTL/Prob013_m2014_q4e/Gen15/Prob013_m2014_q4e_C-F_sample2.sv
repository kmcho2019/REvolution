module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    nor (out, in1, in2);
endmodule