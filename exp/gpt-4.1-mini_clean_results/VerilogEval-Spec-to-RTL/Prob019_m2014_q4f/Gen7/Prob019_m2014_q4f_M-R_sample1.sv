module TopModule (
    input  in1,
    input  in2,
    output reg out
);

// Implement AND gate with a bubble (inversion) on in2 input
// out = in1 AND (NOT in2)
// Using always block with combinational logic
always @(*) begin
    out = in1 & ~in2;
end

endmodule