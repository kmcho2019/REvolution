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

    // Output assignments with clear bit mapping:
    // w[7:0] = a[4:0] + b[4:2] (5 + 3 bits)
    assign w = {a, b[4:2]};
    
    // x[7:0] = b[1:0] + c[4:0] + d[4] (2 + 5 + 1 bits)
    assign x = {b[1:0], c, d[4]};
    
    // y[7:0] = d[3:0] + e[4:1] (4 + 4 bits)
    assign y = {d[3:0], e[4:1]};
    
    // z[7:0] = e[0] + f[4:0] + 2'b11 (1 + 5 + 2 bits)
    assign z = {e[0], f, 2'b11};

endmodule