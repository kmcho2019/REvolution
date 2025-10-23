module TopModule(
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

// Define a lookup table to map scancodes to arrow key outputs
reg [3:0] lut [16'hffff:16'h0000];

initial begin
    // Initialize the lookup table with default values (none)
    for (int i = 0; i < 16'h10000; i++) begin
        lut[i] = 4'b0000;
    end

    // Map specific scancodes to their corresponding arrow key outputs
    lut[16'he06b] = 4'b0001; // Left arrow
    lut[16'he072] = 4'b0010; // Down arrow
    lut[16'he074] = 4'b0100; // Right arrow
    lut[16'he075] = 4'b1000; // Up arrow
end

// Use the lookup table to determine the output values
always @(*) begin
    reg [3:0] output;
    output = lut[scancode];
    {up, right, down, left} = output;
end

endmodule