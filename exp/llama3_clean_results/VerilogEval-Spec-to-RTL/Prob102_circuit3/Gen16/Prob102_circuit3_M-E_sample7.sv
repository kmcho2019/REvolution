// Define the TopModule with a novel, simplified logic expression
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Directly compute the output q using a complex logic expression
    assign q = (a | b) & (c | d);

endmodule