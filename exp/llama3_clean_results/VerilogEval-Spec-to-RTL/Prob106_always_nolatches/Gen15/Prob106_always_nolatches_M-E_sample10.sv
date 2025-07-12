module TopModule_LUT(
    input  [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

// Define the lookup table
reg [3:0] lut [16'he075:16'he06b];

initial begin
    // Initialize the lookup table
    lut[16'he06b] = 4'b1000; // left
    lut[16'he072] = 4'b0100; // down
    lut[16'he074] = 4'b0010; // right
    lut[16'he075] = 4'b0001; // up
end

always @(*) begin
    // Use the scancode as an address to retrieve the output values
    if (scancode >= 16'he06b && scancode <= 16'he075) begin
        {left, down, right, up} = lut[scancode];
    end else begin
        {left, down, right, up} = 4'b0000; // default values
    end
end

endmodule