module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

// Continuously update output signals based on input values
always @(*)
begin
    // Directly assign comparison results to output signals
    A_greater = (A > B);
    A_equal = (A == B);
    A_less = (A < B);
end

endmodule