module TopModule(
    input  x,
    input  y,
    output z
);

// Create a 2-input LUT to store the output values for all possible input combinations
reg [1:0] lut [3:0];

// Initialize the LUT with the output values
initial begin
    lut[0] = 2'b01; // x = 0, y = 0, z = 1
    lut[1] = 2'b00; // x = 0, y = 1, z = 0
    lut[2] = 2'b00; // x = 1, y = 0, z = 0
    lut[3] = 2'b01; // x = 1, y = 1, z = 1
end

// Use the inputs x and y to index into the LUT and retrieve the corresponding output value
assign z = lut[{x, y}][0];

endmodule