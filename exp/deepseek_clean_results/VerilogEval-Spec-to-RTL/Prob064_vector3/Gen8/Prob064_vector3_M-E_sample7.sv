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

    // Bit distribution pattern:
    // Each 5-bit input is split as [4:2] and [1:0]
    // These are distributed to outputs in rotating fashion
    // Padding bits (1'b1) are added to fill remaining LSBs
    
    // Output w gets:
    // a[4:2], b[1:0], c[4:3], 1'b1
    assign w = {a[4:2], b[1:0], c[4:3], 1'b1};
    
    // Output x gets:
    // c[2:0], d[4], e[4:2], 1'b1
    assign x = {c[2:0], d[4], e[4:2], 1'b1};
    
    // Output y gets:
    // d[3:0], e[1:0], f[4], 2'b11
    assign y = {d[3:0], e[1:0], f[4], 2'b11};
    
    // Output z gets:
    // f[3:0], a[1:0], b[4:3], 2'b11
    assign z = {f[3:0], a[1:0], b[4:3], 2'b11};

endmodule