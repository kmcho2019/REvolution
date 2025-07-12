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

    // Create 32-bit buffer with explicit padding
    wire [31:0] buffer;
    assign buffer = {a, b, c, d, e, f, 2'b11};

    // Extract 8-bit segments using explicit bit ranges
    assign w = buffer[31:24];
    assign x = buffer[23:16];
    assign y = buffer[15:8];
    assign z = buffer[7:0];

endmodule