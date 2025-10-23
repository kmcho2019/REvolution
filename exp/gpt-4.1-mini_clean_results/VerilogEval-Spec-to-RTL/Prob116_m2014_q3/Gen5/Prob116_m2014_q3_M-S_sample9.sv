module TopModule (
    input  [3:0] x,  // x[3], x[2], x[1], x[0]
    output       f
);

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Row bits = {x3, x0}, column bits = {x1, x2}
    // Minterms where f=1:
    // (x3,x0) = 11 (x3=1,x0=1), col=00 => x1=0, x2=0
    wire m1 = x3 & x0 & ~x1 & ~x2;

    // (x3,x0)=11, col=01 => x1=0, x2=1
    wire m2 = x3 & x0 & ~x1 & x2;

    // (x3,x0)=10 (x3=1, x0=0), col=00 => x1=0, x2=0
    wire m3 = x3 & ~x0 & ~x1 & ~x2;

    // (x3,x0)=10, col=01 => x1=0, x2=1
    wire m4 = x3 & ~x0 & ~x1 & x2;

    // (x3,x0)=01 (x3=0, x0=1), col=11 => x1=1, x2=1
    wire m5 = ~x3 & x0 & x1 & x2;

    assign f = m1 | m2 | m3 | m4 | m5;

endmodule