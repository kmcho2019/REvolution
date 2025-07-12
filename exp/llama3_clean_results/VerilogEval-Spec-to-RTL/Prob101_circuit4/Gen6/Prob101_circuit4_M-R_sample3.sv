module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Use a combinational always block instead of an assign statement
always @(*) begin
    // Use a temporary variable to store the result of the OR operation
    wire temp;
    // The output q is the logical OR of inputs b and c
    temp = b || c;
    // Assign the result to the output q
    q = temp;
end

endmodule