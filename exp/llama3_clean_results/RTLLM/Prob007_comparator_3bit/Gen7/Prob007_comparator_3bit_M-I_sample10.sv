// The original code provided is already quite optimized for a simple 3-bit comparator.
// Given the small size and straightforward logic, significant optimizations might not be feasible.
// However, ensuring proper synthesis and considering system-level optimizations could further improve PPA metrics.

module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*) begin
    // The current comparison logic is straightforward and efficient for a 3-bit comparator.
    A_greater = (A > B);
    A_equal = (A == B);
    A_less = (A < B);
end

endmodule