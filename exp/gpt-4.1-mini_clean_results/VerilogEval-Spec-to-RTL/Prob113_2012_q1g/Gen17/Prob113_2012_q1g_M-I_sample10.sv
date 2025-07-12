module TopModule(
    input  [3:0] x,
    output       f
);

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Factor common terms:
    // Original:
    // f = (~x3 & ~x1) 
    //   | (x2 & x1 & ~x0 & ~x3) 
    //   | (x3 & x2 & (~x0 | x1));
    //
    // Factor out x2:
    // f = (~x3 & ~x1) 
    //   | (x2 & ( (~x3 & x1 & ~x0) | (x3 & (~x0 | x1)) ));
    //
    // Inside parentheses:
    // (~x3 & x1 & ~x0) | (x3 & ~x0) | (x3 & x1)
    // = ~x0 & ( (~x3 & x1) | x3 ) | (x3 & x1)
    //
    // Note (~x3 & x1) | x3 = x3 | x1 (since if x3=1 then true, else check x1)
    // So ~x0 & (x3 | x1) | (x3 & x1)
    //
    // (x3 & x1) is included in (x3 | x1), so f = ~x0 & (x3 | x1) | (x3 & x1)
    // This can be simplified to (x3 & x1) | (~x0 & (x3 | x1))
    // which is already concise.

    wire part = (x3 & x1) | (~x0 & (x3 | x1));

    assign f = (~x3 & ~x1) | (x2 & part);

endmodule