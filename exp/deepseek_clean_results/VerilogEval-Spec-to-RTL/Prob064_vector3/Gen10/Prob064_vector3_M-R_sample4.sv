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

    // Output w: First 8 bits (a + top 3 bits of b)
    assign w = {a, b[4:2]};
    
    // Output x: Next 8 bits (remaining 2 bits of b + all of c + top 1 bit of d)
    assign x = {b[1:0], c, d[4]};
    
    // Output y: Next 8 bits (remaining 4 bits of d + all of e)
    assign y = {d[3:0], e};
    
    // Output z: Last 8 bits (all of f + padding 1's in LSBs)
    assign z = {f, 2'b11};

endmodule