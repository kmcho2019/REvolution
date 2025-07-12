module TopModule(
    input in1,
    input in2,
    output reg out
);

// Implementing the NAND operation using an always block
always @(*) begin
    // The bubble on in2 implies inversion, thus in1 & ~in2 directly implements the required logic
    out = in1 & ~in2;
end

endmodule