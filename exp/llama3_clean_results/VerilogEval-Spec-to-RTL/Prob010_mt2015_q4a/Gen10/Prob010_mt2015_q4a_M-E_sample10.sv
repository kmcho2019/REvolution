/**
 * Module TopModule implements the boolean function z = (x^y) & x.
 *
 * @param x  Input signal x.
 * @param y  Input signal y.
 * @param z  Output signal z, which is the result of (x^y) & x.
 */
module TopModule(
    input  logic x,  // Input signal x
    input  logic y,  // Input signal y
    output logic z   // Output signal z
);

// Directly implement the combined logic for z = (x^y) & x
// Using the property that (x^y) = x when y=0 and (x^y) = ~x when y=1,
// and then applying this to the AND operation, we simplify the expression.
assign z = (x && (!y)) || ((~x) && y && x);

// Alternatively, a simpler and more direct implementation considering the Boolean properties:
assign z = x && (!y);

// Another approach leveraging the same principles but focusing on the XOR's behavior:
assign z = (~y) && x;

// The most straightforward and minimal implementation, directly from the expression z = (x^y) & x:
assign z = (x ^ y) & x;

endmodule