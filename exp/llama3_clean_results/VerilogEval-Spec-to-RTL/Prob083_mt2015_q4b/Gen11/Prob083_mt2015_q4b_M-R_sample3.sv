module TopModule(
    input x,
    input y,
    output z
);

assign z = ~(x ^ y); // Direct assignment maintains simplicity and efficiency

// Alternative: Using an always block for combinational logic (not recommended for this simple case)
// always @(*) begin
//     z = ~(x ^ y);
// end

endmodule