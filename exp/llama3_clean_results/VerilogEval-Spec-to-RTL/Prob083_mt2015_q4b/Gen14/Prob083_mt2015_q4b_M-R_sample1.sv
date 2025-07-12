module TopModule(
    input x,
    input y,
    output z
);

// Refactored implementation using an always block
// This approach does not necessarily offer advantages over the assign statement
// for purely combinational logic but can be a starting point for more complex designs.
always @(*) begin
    // The logic remains the same: z is 1 if x and y are the same (both 0 or both 1)
    z = ~(x ^ y);
end

// Alternatively, maintaining the assign statement for simplicity and efficiency:
// assign z = ~(x ^ y);

endmodule