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

    wire [29:0] concat_30;
    wire [31:0] concat_32;

    // First concatenate the six 5-bit inputs into 30 bits
    assign concat_30 = {a, b, c, d, e, f};

    // Append two 1 bits at LSB to make a 32-bit vector
    assign concat_32 = {concat_30, 2'b11};

    // Slice the 32-bit vector into four 8-bit outputs
    assign w = concat_32[31:24];
    assign x = concat_32[23:16];
    assign y = concat_32[15:8];
    assign z = concat_32[7:0];

endmodule