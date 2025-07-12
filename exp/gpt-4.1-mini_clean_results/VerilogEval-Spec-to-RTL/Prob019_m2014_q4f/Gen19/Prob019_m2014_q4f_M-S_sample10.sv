module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Direct combinational logic for out = in1 AND (NOT in2)
    assign out = in1 & ~in2;
endmodule