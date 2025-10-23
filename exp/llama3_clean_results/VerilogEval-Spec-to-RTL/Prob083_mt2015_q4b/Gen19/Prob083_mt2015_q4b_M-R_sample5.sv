// TopModule: Implements an XNOR gate
// This module takes two input signals, x and y, and produces an output z.
// The output z is high (1) when both x and y are the same (either both 0 or both 1),
// and low (0) when x and y are different.
module TopModule(
    input x,  // Input signal x
    input y,  // Input signal y
    output reg z  // Output signal z, high when x and y are the same
);

// The XNOR gate is implemented using the efficient logical expression !(x ^ y)
// This expression is equivalent to (x == y), ensuring z is high when x and y are the same
always @(*) begin
    // Using always block for combinatorial logic, including all inputs in the sensitivity list
    z = !(x ^ y); // Assign the result of the XNOR operation to output z
end

endmodule