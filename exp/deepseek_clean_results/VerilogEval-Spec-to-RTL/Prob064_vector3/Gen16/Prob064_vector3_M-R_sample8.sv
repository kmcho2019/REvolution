module TopModule (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z
);

    // Combine all inputs into a 30-bit vector
    wire [29:0] combined_inputs = {a, b, c, d, e, f};
    
    // Create 32-bit output with 2'b11 LSBs
    wire [31:0] full_output = {combined_inputs, 2'b11};
    
    // Split into four 8-bit outputs
    assign w = full_output[31:24];
    assign x = full_output[23:16];
    assign y = full_output[15:8];
    assign z = full_output[7:0];

endmodule