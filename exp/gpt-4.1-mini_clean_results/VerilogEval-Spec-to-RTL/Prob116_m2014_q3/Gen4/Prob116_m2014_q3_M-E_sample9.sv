module TopModule (
    input  [3:0] x,
    output      f
);

    // Assign meaningful names to bits for clarity
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Implement minimal SOP from K-map analysis:
    // f = (x3 & ~x1) | (~x3 & x0 & x1 & x2)
    assign f = (x3 & ~x1) | (~x3 & x0 & x1 & x2);

endmodule