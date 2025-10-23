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

    // Constant two bits '11' to be appended at LSB positions
    localparam [1:0] APPENDED_BITS = 2'b11;

    // Direct concatenation of all inputs with appended bits
    wire [31:0] combined = {a, b, c, d, e, f, APPENDED_BITS};

    // Split combined 32-bit vector into four 8-bit outputs
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule