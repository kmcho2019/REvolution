module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

    wire f0, f1;

    // For x3=0, f = x2
    assign f0 = x2;
    // For x3=1, f = x1 & ~x2
    assign f1 = x1 & (~x2);

    // Multiplexer selecting between f0 and f1 based on x3
    assign f = x3 ? f1 : f0;

endmodule