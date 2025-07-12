/**
 * TopModule: Implements an XNOR gate
 * Output z is 1 when inputs x and y are equal (both 0 or both 1)
 * Output z is 0 when inputs x and y are different
 */
module TopModule (
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // XNOR operation
endmodule