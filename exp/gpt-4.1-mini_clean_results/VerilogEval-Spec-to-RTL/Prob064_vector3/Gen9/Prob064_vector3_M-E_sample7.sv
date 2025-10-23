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

    // Assemble w from 'a' and upper 3 bits of 'b'
    assign w = {a, b[4:2]};

    // Assemble x from lower 2 bits of 'b' and all bits of 'c'
    assign x = {b[1:0], c};

    // Assemble y from 'd' and upper 3 bits of 'e'
    assign y = {d, e[4:2]};

    // Assemble z from lower 2 bits of 'e', 'f', and 2'b11 LSB bits
    assign z = {e[1:0], f, 2'b11};

endmodule