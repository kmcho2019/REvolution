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

    // w gets a[4:0] and b[4:2] (8 bits total)
    assign w = {a, b[4:2]};
    
    // x gets b[1:0], c, d[4:4] (8 bits total)
    assign x = {b[1:0], c, d[4]};
    
    // y gets d[3:0], e[4:1] (8 bits total)
    assign y = {d[3:0], e[4:1]};
    
    // z gets e[0], f, and the 2'b11 padding (8 bits total)
    assign z = {e[0], f, 2'b11};

endmodule