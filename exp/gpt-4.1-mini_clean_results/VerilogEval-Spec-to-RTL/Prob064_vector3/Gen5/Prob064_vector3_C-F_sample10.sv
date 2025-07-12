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

    // Named constant for appended two LSB '1' bits
    localparam [1:0] CONST_ONES = 2'b11;

    // Concatenate inputs (30 bits) plus CONST_ONES at LSB to form 32-bit vector
    wire [31:0] combined = {a, b, c, d, e, f, CONST_ONES};

    // Slice combined vector into four 8-bit outputs from MSB to LSB
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule