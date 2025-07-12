module TopModule(
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

    // Output w: a[4:0] + b[4:3]
    assign w = {a, b[4:3]};

    // Output x: b[2:0] + c + d[4]
    assign x = {b[2:0], c, d[4]};

    // Output y: d[3:0] + e[4:1]
    assign y = {d[3:0], e[4:1]};

    // Output z: e[0] + f + 2'b11
    assign z = {e[0], f, 2'b11};

endmodule