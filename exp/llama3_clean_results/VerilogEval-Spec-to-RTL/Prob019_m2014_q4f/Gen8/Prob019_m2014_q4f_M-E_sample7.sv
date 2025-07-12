module TopModule(
    input in1,
    input in2,
    output reg out
);

reg not_in2; // Intermediate signal to hold the inversion of in2
reg nand_out; // Intermediate signal to hold the output of the NAND operation

always @(*) begin
    not_in2 = ~in2; // Invert in2
    nand_out = ~(in1 & not_in2); // Perform NAND operation
    out = ~nand_out; // Invert the result to get the final output
end

endmodule