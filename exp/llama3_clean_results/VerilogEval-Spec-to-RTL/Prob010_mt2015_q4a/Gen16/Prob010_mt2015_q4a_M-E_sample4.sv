/**
 * Module TopModule implements the boolean function z = (x^y) & x using a lookup table.
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

// Use a combinational always block to define the output z based on inputs x and y
always_comb begin
    // Utilize a case statement to implement the LUT
    case ({x, y})
        2'b00: z = 1'b0;  // x = 0, y = 0, z = (0^0) & 0 = 0
        2'b01: z = 1'b0;  // x = 0, y = 1, z = (0^1) & 0 = 0
        2'b10: z = 1'b1;  // x = 1, y = 0, z = (1^0) & 1 = 1
        2'b11: z = 1'b0;  // x = 1, y = 1, z = (1^1) & 1 = 0
    endcase
end

endmodule