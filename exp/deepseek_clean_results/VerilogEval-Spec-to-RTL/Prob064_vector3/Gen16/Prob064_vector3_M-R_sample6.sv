module TopModule (
    input [4:0] a,  // 5-bit input
    input [4:0] b,  // 5-bit input
    input [4:0] c,  // 5-bit input
    input [4:0] d,  // 5-bit input
    input [4:0] e,  // 5-bit input
    input [4:0] f,  // 5-bit input
    output [7:0] w, // 8-bit output (MSBs)
    output [7:0] x, // 8-bit output
    output [7:0] y, // 8-bit output
    output [7:0] z  // 8-bit output (includes padding LSBs)
);

    // w gets first 8 bits: a (5) + b[4:2] (3)
    assign w = {a, b[4:2]};
    
    // x gets next 8 bits: b[1:0] (2) + c (5) + d[4] (1)
    assign x = {b[1:0], c, d[4]};
    
    // y gets next 8 bits: d[3:0] (4) + e (4) [only 4 bits of e used]
    assign y = {d[3:0], e[4:1]};
    
    // z gets last 8 bits: e[0] (1) + f (5) + padding (2'b11)
    assign z = {e[0], f, 2'b11};

endmodule