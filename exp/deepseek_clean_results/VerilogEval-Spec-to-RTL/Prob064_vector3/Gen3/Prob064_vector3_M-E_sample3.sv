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

    // Output w: bits 29-22 (a[4:2], b[4:0], c[4])
    assign w = {a[4:2], b[4:0], c[4]};

    // Output x: bits 21-14 (c[3:0], d[4:0], e[4:3])
    assign x = {c[3:0], d[4:0], e[4:3]};

    // Output y: bits 13-6 (e[2:0], f[4:0])
    assign y = {e[2:0], f[4:0]};

    // Output z: bits 5-0 (f[4:0] is only 5 bits, pad with 2'b11)
    assign z = {f[4:0], 2'b11};

endmodule