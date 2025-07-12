module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1 (Gray code)
    output       f
);

    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // From the Karnaugh map and considering inputs directly (Gray code bits):
    // Minterms where f=1 (from K-map):
    // row x4x3 / col x2x1
    // 11 / 00: x4=1,x3=1,x2=0,x1=0 => x=1100
    // 11 / 01: 1 1 0 1 => 1101
    // 01 / 11: 0 1 1 1 => 0111
    // 10 / 00: 1 0 0 0 => 1000
    // 10 / 01: 1 0 0 1 => 1001

    // Write minterm expressions for these values (x[3]..x[0]):
    // Using x[3] = x4, ..., x[0] = x1

    wire m1 = x4 & x3 & ~x2 & ~x1; // 1100
    wire m2 = x4 & x3 & ~x2 &  x1; // 1101
    wire m3 = ~x4 & x3 &  x2 &  x1; // 0111
    wire m4 = x4 & ~x3 & ~x2 & ~x1; // 1000
    wire m5 = x4 & ~x3 & ~x2 &  x1; // 1001

    // Combine all minterms
    assign f = m1 | m2 | m3 | m4 | m5;

endmodule