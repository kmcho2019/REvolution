module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Refactored version maintaining the same logic but using a temporary variable for clarity.
wire temp1, temp2;
assign temp1 = ~x3 & x2; // Condition when x3 is low and x2 is high
assign temp2 = x3 & x1;  // Condition when x3 is high and x1 is high
assign f = temp1 | temp2; // Output is true if either condition is met

endmodule