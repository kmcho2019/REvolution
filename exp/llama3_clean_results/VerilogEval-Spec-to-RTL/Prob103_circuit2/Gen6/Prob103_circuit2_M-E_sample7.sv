module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Count the number of 1s among the inputs
wire count = a + b + c + d;

// Determine the output q based on the parity of the count
assign q = ~(count[0]);

endmodule