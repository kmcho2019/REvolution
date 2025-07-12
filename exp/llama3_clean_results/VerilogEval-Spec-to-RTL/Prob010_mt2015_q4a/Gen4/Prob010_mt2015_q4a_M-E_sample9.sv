/**
 * Module TopModuleAlternative implements the boolean function z = (x^y) & x using an alternative approach.
 *
 * @param x  Input signal x.
 * @param y  Input signal y.
 * @param z  Output signal z, which is the result of (x^y) & x.
 */
module TopModuleAlternative(
    input  logic x,  // Input signal x
    input  logic y,  // Input signal y
    output logic z   // Output signal z
);

// Use a conditional statement to explicitly define the output
always_comb begin
    if (x) begin
        // When x is true, z is true only if x^y is true
        z = (x ^ y);
    end else begin
        // When x is false, z will always be false
        z = 1'b0;
    end
end

endmodule