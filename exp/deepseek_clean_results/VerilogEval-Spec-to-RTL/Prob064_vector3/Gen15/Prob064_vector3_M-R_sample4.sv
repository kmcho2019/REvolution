module TopModule (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z
);

    // First output: bits 31-24 (a and part of b)
    assign w = {a, b[4:2]};
    
    // Second output: bits 23-16 (rest of b and part of c)
    assign x = {b[1:0], c, d[4]};
    
    // Third output: bits 15-8 (rest of d and part of e)
    assign y = {d[3:0], e[4:1]};
    
    // Fourth output: bits 7-0 (rest of e, all of f, and two '1' bits)
    assign z = {e[0], f, 2'b11};

endmodule