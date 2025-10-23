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

    // w gets a (5 bits) + b[4:2] (3 bits)
    assign w = {a, b[4:2]};

    // x gets b[1:0] (2 bits) + c (5 bits) + d[4] (1 bit)
    assign x = {b[1:0], c, d[4]};

    // y gets d[3:0] (4 bits) + e (5 bits) - 1 bit short, so we take f[4]
    assign y = {d[3:0], e, f[4]};

    // z gets f[3:0] (4 bits) + 2'b11
    assign z = {f[3:0], 2'b11};

endmodule