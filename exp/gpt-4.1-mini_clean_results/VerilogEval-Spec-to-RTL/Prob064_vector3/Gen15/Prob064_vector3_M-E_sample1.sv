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

    // First 16-bit intermediate vector: a, b, c plus 1'b1 at LSB
    wire [15:0] half1 = {a, b, c, 1'b1};

    // Second 16-bit intermediate vector: d, e, f plus 1'b1 at LSB
    wire [15:0] half2 = {d, e, f, 1'b1};

    // Full 32-bit concatenation of half1 and half2
    wire [31:0] combined = {half1, half2};

    // Split combined vector into outputs w, x, y, z
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule