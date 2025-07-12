// Improved comparator_3bit module with synthesis optimization directives
module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

// Synthesis optimization directive to prioritize area optimization
// This directive may vary depending on the synthesis tool being used
// For example, with some tools, you might use `(* area_opt *)` or similar
// `attribute area_opt of comparator_3bit : architecture is "high";`
always @(*) begin
    // The comparison logic remains straightforward and efficient
    A_greater = (A > B);
    A_equal = (A == B);
    A_less = (A < B);
end

endmodule