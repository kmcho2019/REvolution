module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [3:0] difference;  // 4-bit to capture borrow/overflow

// Calculate A - B with sign extension
assign difference = {1'b0, A} - {1'b0, B};

// Output logic
assign A_greater = ~difference[3];  // Positive difference
assign A_equal = (difference[2:0] == 3'b0) & ~difference[3];
assign A_less = difference[3];     // Negative difference (borrow occurred)

endmodule