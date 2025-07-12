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

    // w gets all of a and top 3 bits of b
    assign w = {a, b[4:2]};
    
    // x gets remaining 2 bits of b, all of c, and top bit of d
    assign x = {b[1:0], c, d[4]};
    
    // y gets remaining 4 bits of d and all of e
    assign y = {d[3:0], e};
    
    // z gets all of f plus the two constant '1's
    assign z = {f, 2'b11};

endmodule