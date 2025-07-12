// Define the TopModule with direct implementation of 7420 chip functionality
module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

// Directly assign p1y as the negation of the conjunction of p1a, p1b, p1c, and p1d
assign p1y = ~(p1a & p1b & p1c & p1d);

// Directly assign p2y as the negation of the conjunction of p2a, p2b, p2c, and p2d
assign p2y = ~(p2a & p2b & p2c & p2d);

endmodule