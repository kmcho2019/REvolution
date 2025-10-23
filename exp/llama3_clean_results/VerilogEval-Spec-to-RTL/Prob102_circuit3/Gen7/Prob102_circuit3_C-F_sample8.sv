module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Use intermediate variables to break down the conditions
wire ab;
wire cd;

// Assign the intermediate variables
assign ab = a | b;
assign cd = c | d;

// Use a single assign statement for the final output
assign q = ab & cd;

endmodule