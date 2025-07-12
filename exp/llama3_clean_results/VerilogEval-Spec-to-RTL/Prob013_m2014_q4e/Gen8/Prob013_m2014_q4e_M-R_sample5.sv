module TopModule(
    input  in1,
    input  in2,
    output out
);

// Refactored implementation using a combinational always block
always @(*)
    out = ~in1 & ~in2;

endmodule