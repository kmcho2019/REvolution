module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Combine all inputs into a single 30-bit vector
    wire [29:0] combined_inputs = {a, b, c, d, e, f};
    
    // Create final 32-bit vector with padding
    wire [31:0] padded_output = {combined_inputs, 2'b11};
    
    // Split into individual 8-bit outputs
    assign w = padded_output[31:24];
    assign x = padded_output[23:16];
    assign y = padded_output[15:8];
    assign z = padded_output[7:0];

endmodule