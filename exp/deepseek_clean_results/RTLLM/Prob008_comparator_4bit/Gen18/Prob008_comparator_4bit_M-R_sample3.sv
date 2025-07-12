module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Calculate 4-bit difference (A - B) using two's complement
wire [4:0] diff = {1'b0, A} - {1'b0, B};

// Output assignments
assign A_greater = ~diff[4] && (|diff[3:0]);  // Positive and non-zero
assign A_equal = ~(|diff[3:0]);               // All bits zero
assign A_less = diff[4];                      // Negative (borrow occurred)

endmodule