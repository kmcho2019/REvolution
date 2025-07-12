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

    // Build w from a and part of b
    assign w = {a, b[4:2]};
    
    // Build x from remaining b, c, and part of d
    assign x = {b[1:0], c, d[4:4]};
    
    // Build y from remaining d, e, and part of f
    assign y = {d[3:0], e[4:1]};
    
    // Build z from remaining e, f, and padding
    assign z = {e[0], f, 2'b11};

endmodule