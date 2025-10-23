module TopModule(
    input  [3:0] x,
    output       f
);

// Assign input bits explicitly for clarity and correctness
wire x3 = x[3];  // Karnaugh map row LSB
wire x2 = x[2];  // Karnaugh map row MSB
wire x1 = x[1];  // Karnaugh map column LSB
wire x0 = x[0];  // Karnaugh map column MSB

// Optimized minimal factored expression combining Example 1 minimal form
assign f = (~x3 & ~x1)
        | (~x3 & x2 & x1 & ~x0)
        | (x3 & x2 & (~x0 | (x1 & x0)));

endmodule