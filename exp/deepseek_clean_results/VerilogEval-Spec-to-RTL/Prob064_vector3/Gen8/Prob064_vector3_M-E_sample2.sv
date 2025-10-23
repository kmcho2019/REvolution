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

    // Concatenate all inputs with two 1's in LSB
    wire [31:0] combined = {a, b, c, d, e, f, 2'b11};
    
    // Rotate left by 2 bits for different distribution
    wire [31:0] rotated = {combined[29:0], combined[31:30]};
    
    // Split into four 8-bit outputs
    assign w = rotated[31:24];
    assign x = rotated[23:16];
    assign y = rotated[15:8];
    assign z = rotated[7:0];

endmodule