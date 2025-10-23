module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

    // Minterms where f=1:
    // 0 1 0 -> ~x3 & x2 & ~x1
    // 0 1 1 -> ~x3 & x2 & x1
    // 1 0 1 -> x3 & ~x2 & x1
    // 1 1 1 -> x3 & x2 & x1

    wire m1 = ~x3 & x2 & ~x1;
    wire m2 = ~x3 & x2 & x1;
    wire m3 = x3 & ~x2 & x1;
    wire m4 = x3 & x2 & x1;

    assign f = m1 | m2 | m3 | m4;

endmodule