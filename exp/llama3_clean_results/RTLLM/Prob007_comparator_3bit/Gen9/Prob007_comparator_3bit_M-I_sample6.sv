// Optimized 3-bit comparator module
module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

// Use a single always block to reduce area usage
always @(*) begin
    // Perform comparisons and assign results directly
    A_greater = (A > B) ? 1'b1 : 1'b0;
    A_equal = (A == B) ? 1'b1 : 1'b0;
    // A_less can be derived from the previous two conditions
    A_less = ~(A_greater | A_equal);
end

endmodule