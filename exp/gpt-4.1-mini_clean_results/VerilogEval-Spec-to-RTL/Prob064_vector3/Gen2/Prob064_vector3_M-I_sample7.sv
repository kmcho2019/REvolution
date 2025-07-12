module TopModule(
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
    // Directly assign outputs by concatenating inputs and constant bits
    assign w = {a, b[4:2]};            // 5 + 3 bits = 8 bits
    assign x = {b[1:0], c, d[4]};      // 2 + 5 + 1 bits = 8 bits
    assign y = {d[3:0], e[4:1]};       // 4 + 4 bits = 8 bits
    assign z = {e[0], f, 2'b11};        // 1 + 5 + 2 bits = 8 bits
endmodule