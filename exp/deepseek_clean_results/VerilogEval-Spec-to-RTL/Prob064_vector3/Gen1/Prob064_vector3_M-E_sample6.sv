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

    // Concatenate all inputs and add two '1' bits at MSB
    wire [31:0] combined = {2'b11, a, b, c, d, e, f};

    // Rotate right by 2 positions to move '1's to LSB
    wire [31:0] rotated = {combined[1:0], combined[31:2]};

    // Split the rotated 32-bit value into four 8-bit outputs
    assign w = rotated[31:24];
    assign x = rotated[23:16];
    assign y = rotated[15:8];
    assign z = rotated[7:0];

endmodule