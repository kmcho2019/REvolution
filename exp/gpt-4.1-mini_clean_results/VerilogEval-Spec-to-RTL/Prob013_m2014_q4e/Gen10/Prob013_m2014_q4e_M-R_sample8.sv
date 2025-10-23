module TopModule (
    input wire in1,
    input wire in2,
    output wire out
);
    // Directly assign the NOR of in1 and in2 to out
    assign out = ~(in1 | in2);
endmodule