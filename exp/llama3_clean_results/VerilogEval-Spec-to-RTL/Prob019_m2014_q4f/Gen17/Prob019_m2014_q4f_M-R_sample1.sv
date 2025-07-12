module TopModule(
    input in1,
    input in2,
    output reg out
);
// Implementing a NAND operation directly by inverting in2 before the AND operation
// This is equivalent to an AND gate with a bubble on the in2 input
always @(*) begin
    out = in1 & ~in2;
end

endmodule