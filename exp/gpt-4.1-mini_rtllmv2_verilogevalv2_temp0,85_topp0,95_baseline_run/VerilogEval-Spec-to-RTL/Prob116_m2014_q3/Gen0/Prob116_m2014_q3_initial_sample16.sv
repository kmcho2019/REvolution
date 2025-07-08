module TopModule (
    input  [3:0] x,
    output      f
);

    // Define variables for indexing clarity
    wire x4 = x[3]; // MSB
    wire x3 = x[2];
    wire x2 = x[1];
    wire x1 = x[0]; // LSB

    // row = x4 x3
    wire [1:0] row = {x4, x3};
    // col = x2 x1
    wire [1:0] col = {x2, x1};

    // Based on Karnaugh map:
    // For convenience, we assign don't-cares (d) to zero or one to simplify logic:
    // Let's choose:
    // row=0, col=00: d=0
    // row=0, col=11: d=0
    // row=0, col=10: d=0
    // row=1, col=01: d=0
    // row=3, col=11: d=0
    // row=3, col=10: d=0
    // row=2, col=10: d=0

    // We'll implement the function by enumerating minterms where f=1:

    // Minterms where f=1:
    // row=1 col=11 => x4x3=01, x2x1=11 => x4=0,x3=1,x2=1,x1=1 => 0 1 1 1 = 7
    // row=3 col=00 => x4x3=11, x2x1=00 => 1 1 0 0 = 12
    // row=3 col=01 => 1 1 0 1 = 13
    // row=2 col=00 => 1 0 0 0 = 8
    // row=2 col=01 => 1 0 0 1 = 9

    // We can write f as the OR of these minterms.

    assign f = 
        (x == 4'd7)  // 0111
     || (x == 4'd12) // 1100
     || (x == 4'd13) // 1101
     || (x == 4'd8)  // 1000
     || (x == 4'd9); // 1001

endmodule