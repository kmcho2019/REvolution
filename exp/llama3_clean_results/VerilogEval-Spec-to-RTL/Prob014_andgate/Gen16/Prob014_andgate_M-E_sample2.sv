// Module: TopModule
// Description: A 2-input AND gate implementation using a lookup table (LUT).
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output reg out  // Output of the AND gate
);

// Define the lookup table (LUT) for the AND gate
reg [1:0] lut_address;
reg lut_out;

always @(*) begin
    // Create the LUT address by concatenating the input bits
    lut_address = {a, b};
    
    // Use a case statement to define the LUT contents
    case(lut_address)
        2'b00: lut_out = 1'b0;  // Output for inputs 00
        2'b01: lut_out = 1'b0;  // Output for inputs 01
        2'b10: lut_out = 1'b0;  // Output for inputs 10
        2'b11: lut_out = 1'b1;  // Output for inputs 11
        default: lut_out = 1'b0;  // Default output
    endcase
    
    // Assign the LUT output to the module output
    out = lut_out;
end

endmodule