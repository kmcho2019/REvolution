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

    // Assign outputs by selecting bits from inputs and adding trailing two '1' bits in z
    // The concatenation order is: a (bits 31:27), b (26:22), c (21:17), d (16:12), e (11:7), f (6:2), then 2'b11 (1:0)
    // Assign accordingly to outputs w (31:24), x (23:16), y (15:8), z (7:0)

    // w = a[4:0], b[4:2]
    assign w = {a, b[4:2]}; // 5 + 3 = 8 bits

    // x = b[1:0], c[4:0], d[4]
    assign x = {b[1:0], c, d[4]}; // 2 + 5 + 1 = 8 bits

    // y = d[3:0], e[4:1]
    assign y = {d[3:0], e[4:1]}; // 4 + 4 = 8 bits

    // z = e[0], f, 2'b11
    assign z = {e[0], f, 2'b11}; // 1 + 5 + 2 = 8 bits

endmodule