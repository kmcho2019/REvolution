/**
 * Module TopModule implements the boolean function z = (x^y) & x using a Look-Up Table (LUT).
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

// Define the LUT for the boolean function z = (x^y) & x
// The LUT is essentially a truth table for the function
// For inputs (x, y), the output z is as follows:
// - (0, 0) -> 0
// - (0, 1) -> 0
// - (1, 0) -> 1
// - (1, 1) -> 0
always @(*) begin
    case ({x, y})
        2'b00: z = 1'b0;  // (0, 0) -> 0
        2'b01: z = 1'b0;  // (0, 1) -> 0
        2'b10: z = 1'b1;  // (1, 0) -> 1
        2'b11: z = 1'b0;  // (1, 1) -> 0
        default: z = 1'b0;  // Default case to handle any other input combination
    endcase
end

endmodule