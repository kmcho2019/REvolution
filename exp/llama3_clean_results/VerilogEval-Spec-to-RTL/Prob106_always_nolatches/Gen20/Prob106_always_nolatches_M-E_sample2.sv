module TopModule(
    input  wire [15:0] scancode,
    output reg          left,
    output reg          down,
    output reg          right,
    output reg          up
);

reg [3:0] lut[65536]; // 2D array to store the lookup table

// Initialize the lookup table
initial begin
    // Initialize all outputs to 0 by default
    for (int i = 0; i < 65536; i++) begin
        lut[i] = 4'b0000;
    end
    
    // Set the outputs for the specific scancodes
    lut[16'he06b] = 4'b1000; // left arrow
    lut[16'he072] = 4'b0100; // down arrow
    lut[16'he074] = 4'b0010; // right arrow
    lut[16'he075] = 4'b0001; // up arrow
end

always @(*) begin
    // Use the lookup table to determine the output
    {left, down, right, up} = lut[scancode];
end

endmodule