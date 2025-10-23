module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Implement out = in1 AND NOT in2 with direct continuous assignment
    assign out = in1 & (~in2);
endmodule