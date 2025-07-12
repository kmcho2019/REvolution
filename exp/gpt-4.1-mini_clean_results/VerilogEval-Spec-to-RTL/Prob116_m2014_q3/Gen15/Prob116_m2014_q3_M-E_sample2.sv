module TopModule(
    input  [3:0] x,
    output      f
);
    // According to the Karnaugh map:
    // Inputs: x[3:0] = {x3, x2, x1, x0}
    // Map rows: x[3]x[2], cols: x[1]x[0]

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Minterms where output f=1 (from K-map):
    // For reference, rows x3x2 and cols x1x0:
    // x3x2=01, x1x0=11 (0b0111 = 7)
    // x3x2=10, x1x0=00,01 (0b1000=8, 0b1001=9)
    // x3x2=11, x1x0=00,01 (0b1100=12,0b1101=13)
    // x3x2=11, x1x0=00 and 01 also means x3=1,x2=1,x1=0,x0=0 or 1
    // x3x2=10, x1x0=00,01 similarly

    // Let's write the minterms:
    // m7 = x3=0,x2=1,x1=1,x0=1 (row=01 col=11)
    // m8 = x3=1,x2=0,x1=0,x0=0 (row=10 col=00)
    // m9 = x3=1,x2=0,x1=0,x0=1 (row=10 col=01)
    // m12= x3=1,x2=1,x1=0,x0=0 (row=11 col=00)
    // m13= x3=1,x2=1,x1=0,x0=1 (row=11 col=01)

    // From these, we can identify groups to minimize:

    // Group A: m12 and m13 -> x3=1, x2=1, x1=0 (x0 don't care)
    wire A = x3 & x2 & ~x1;

    // Group B: m8 and m9 -> x3=1, x2=0, x1=0 (x0 don't care)
    wire B = x3 & ~x2 & ~x1;

    // Group C: m7 alone -> ~x3 & x2 & x1 & x0
    wire C = ~x3 & x2 & x1 & x0;

    // Final output is OR of these groups:
    assign f = A | B | C;

endmodule