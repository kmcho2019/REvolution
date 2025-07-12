// Define the TopModule with clear and concise port names
module TopModule(
    input  [15:0] data_in,  // Input 16-bit data
    output [7:0] upper_byte, // Upper 8 bits of the input
    output [7:0] lower_byte  // Lower 8 bits of the input
);

// Assign the upper 8 bits of the input to the upper_byte output
assign upper_byte = data_in[15:8];

// Assign the lower 8 bits of the input to the lower_byte output
assign lower_byte = data_in[7:0];

endmodule