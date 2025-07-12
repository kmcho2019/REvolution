module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

    // Direct Boolean expression derived from truth table:
    // f = (!x3 & x2) | (x3 & x1)
    assign f = (~x3 & x2) | (x3 & x1);

endmodule