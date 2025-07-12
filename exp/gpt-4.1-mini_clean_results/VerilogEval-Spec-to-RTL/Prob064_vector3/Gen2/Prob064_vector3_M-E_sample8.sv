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

    // Assign w: full a + upper 3 bits of b
    assign w = {a, b[4:2]};

    // Assign x: lower 2 bits of b + full c + upper bit of d
    assign x = {b[1:0], c, d[4]};

    // Assign y: lower 4 bits of d + upper 4 bits of e
    assign y = {d[3:0], e[4:1]};

    // Assign z: lower bit of e + full f + two appended '1's LSB
    assign z = {e[0], f, 2'b11};

endmodule