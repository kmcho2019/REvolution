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

    // Create extended 32-bit buffer with padding
    wire [31:0] extended_buffer = {a, b, c, d, e, f, 2'b11};

    // Circular selection of outputs
    assign w = extended_buffer[31:24];  // First 8 bits
    assign x = extended_buffer[23:16];  // Next 8 bits
    assign y = extended_buffer[15:8];   // Next 8 bits
    assign z = extended_buffer[7:0];    // Last 8 bits (includes padding)

endmodule