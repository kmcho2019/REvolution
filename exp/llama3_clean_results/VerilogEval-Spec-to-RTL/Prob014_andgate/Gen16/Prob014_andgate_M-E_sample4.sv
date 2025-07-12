// Module: TopModule
// Description: The top-level module implementing a 2-input AND gate using a look-up table (LUT) approach.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output out  // Output of the AND gate
);

    // Define the look-up table for the AND gate
    reg [1:0] lut_input;  // Input to the LUT
    reg lut_output;       // Output from the LUT

    // Concatenate inputs a and b to form the LUT input
    assign lut_input = {a, b};

    // Implement the LUT using a case statement
    always @(lut_input) begin
        case (lut_input)
            2'b00: lut_output = 1'b0;  // (a, b) = (0, 0) => out = 0
            2'b01: lut_output = 1'b0;  // (a, b) = (0, 1) => out = 0
            2'b10: lut_output = 1'b0;  // (a, b) = (1, 0) => out = 0
            2'b11: lut_output = 1'b1;  // (a, b) = (1, 1) => out = 1
            default: lut_output = 1'b0;  // Default case for invalid inputs
        endcase
    end

    // Assign the LUT output to the module output
    assign out = lut_output;

endmodule