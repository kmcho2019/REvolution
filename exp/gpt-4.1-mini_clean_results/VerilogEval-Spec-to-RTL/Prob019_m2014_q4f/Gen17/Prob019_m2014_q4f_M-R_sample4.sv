module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);

    // Directly assign output as in1 AND NOT in2, without intermediate wires
    assign out = in1 & (~in2);

endmodule