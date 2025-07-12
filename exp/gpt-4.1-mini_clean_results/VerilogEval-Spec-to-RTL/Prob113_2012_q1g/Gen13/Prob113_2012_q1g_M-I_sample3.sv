module TopModule(
    input  [3:0] x,
    output       f
);

// Assign input bits explicitly for clarity
wire x3 = x[3];  // Karnaugh map row LSB
wire x2 = x[2];  // Karnaugh map row MSB
wire x1 = x[1];  // Karnaugh map column LSB
wire x0 = x[0];  // Karnaugh map column MSB

// Generate complemented signals once to share inverter logic
wire nx3 = ~x3;
wire nx1 = ~x1;
wire nx0 = ~x0;

// Implement the minimal factored boolean expression using complemented signals
assign f = (nx3 & nx1)
        | (x3 & x2 & (nx0 | (x1 & x0)));

endmodule