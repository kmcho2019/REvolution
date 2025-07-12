module TopModule(
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

reg [3:0] lut [16'he07f:16'he06b];

always @(*) begin
    left = lut[scancode][3];
    down = lut[scancode][2];
    right = lut[scancode][1];
    up = lut[scancode][0];
end

initial begin
    lut[16'he06b] = 4'b1000; // Left arrow
    lut[16'he072] = 4'b0100; // Down arrow
    lut[16'he074] = 4'b0010; // Right arrow
    lut[16'he075] = 4'b0001; // Up arrow
    for (int i = 16'he06b; i <= 16'he07f; i++) begin
        if (i != 16'he06b && i != 16'he072 && i != 16'he074 && i != 16'he075) begin
            lut[i] = 4'b0000; // No arrow key pressed
        end
    end
end

endmodule