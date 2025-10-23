module TopModule (
    input  [3:0] x,   // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1 (problem notation)
    output      f
);

    // Map input bits explicitly for clarity (problem notation)
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Define the Karnaugh map as a 2D ROM
    // Rows indexed by {x3, x4}
    // Columns indexed by {x1, x2}
    // Values taken from the problem map; don't-cares assigned to 0
    reg [0:0] Kmap [0:3][0:3];

    initial begin
        // row = 00 (x3=0, x4=0)
        // col=00->d=0, 01->0, 11->d=0, 10->d=0
        Kmap[0][0] = 0;
        Kmap[0][1] = 0;
        Kmap[0][3] = 0;
        Kmap[0][2] = 0;

        // row = 01 (x3=0, x4=1)
        // 00=0, 01=d=0, 11=1, 10=0
        Kmap[1][0] = 0;
        Kmap[1][1] = 0;
        Kmap[1][3] = 1;
        Kmap[1][2] = 0;

        // row = 11 (x3=1, x4=1)
        // 00=1, 01=1, 11=d=0, 10=d=0
        Kmap[3][0] = 1;
        Kmap[3][1] = 1;
        Kmap[3][3] = 0;
        Kmap[3][2] = 0;

        // row = 10 (x3=1, x4=0)
        // 00=1, 01=1, 11=0, 10=d=0
        Kmap[2][0] = 1;
        Kmap[2][1] = 1;
        Kmap[2][3] = 0;
        Kmap[2][2] = 0;
    end

    // Output assignment: use the inputs as indices for the ROM
    assign f = Kmap[{x3,x4}][{x1,x2}];

endmodule