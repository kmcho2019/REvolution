module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output        f
);

    // Name input bits for clarity
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Gray to binary decoding for row (x3,x4)
    wire row1 = x3;
    wire row0 = x3 ^ x4;

    // Gray to binary decoding for column (x1,x2)
    wire col1 = x1;
    wire col0 = x1 ^ x2;

    // Combine into address
    wire [3:0] addr = {row1, row0, col1, col0};

    // Implement function f using direct combinational assignment derived from the case statement
    assign f = (addr == 4'b0110) || // row=01 col=10 -> f=1
               (addr == 4'b1000) || // row=10 col=00 -> f=1
               (addr == 4'b1001) || // row=10 col=01 -> f=1
               (addr == 4'b1100) || // row=11 col=00 -> f=1
               (addr == 4'b1101);   // row=11 col=01 -> f=1

endmodule