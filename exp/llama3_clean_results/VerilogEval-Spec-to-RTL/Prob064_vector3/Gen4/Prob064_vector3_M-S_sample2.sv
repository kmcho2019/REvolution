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

    assign w = {a, b[4]};
    assign x = {b[3:0], c[4:1]};
    assign y = {c[0], d, e[4:3]};
    assign z = {e[2:0], f, 2'b11};

endmodule