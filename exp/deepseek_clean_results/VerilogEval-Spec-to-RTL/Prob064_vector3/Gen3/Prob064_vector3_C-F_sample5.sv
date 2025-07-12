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

    // Direct assignments with explicit bit ranges
    assign w = {a, b[4:2]};                // a[4:0] + b[4:2] = 8 bits
    assign x = {b[1:0], c, d[4:3]};        // b[1:0] + c[4:0] + d[4:3] = 8 bits
    assign y = {d[2:0], e, f[4:5]};        // d[2:0] + e[4:0] + f[4:5] = 8 bits
    assign z = {f[3:0], 2'b11};            // f[3:0] + 2'b11 = 8 bits

endmodule