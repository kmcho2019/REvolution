// TopModule: Implements an XNOR gate using an always block
// This module takes two input signals, x and y, and produces an output z.
// The output z is high (1) when both x and y are the same (either both 0 or both 1),
// and low (0) when x and y are different.
module TopModule(
    input x,  // Input signal x
    input y,  // Input signal y
    output reg z  // Output signal z, high when x and y are the same
);

// The XNOR gate is implemented within an always block for combinational logic
always @(*) begin
    // Check if x and y are the same
    if (x == y) begin
        // If x and y are the same, set z to 1
        z = 1'b1;
    end else begin
        // If x and y are different, set z to 0
        z = 1'b0;
    end
end

endmodule