module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    localparam [1:0] APPENDED_BITS = 2'b11;

    wire [31:0] concat_with_ones;

    // Concatenate inputs in order and append two '1' bits at LSB
    assign concat_with_ones = {a, b, c, d, e, f, APPENDED_BITS};

    // Split 32-bit vector into four 8-bit outputs (MSB to LSB)
    assign w = concat_with_ones[31:24];
    assign x = concat_with_ones[23:16];
    assign y = concat_with_ones[15:8];
    assign z = concat_with_ones[7:0];

endmodule