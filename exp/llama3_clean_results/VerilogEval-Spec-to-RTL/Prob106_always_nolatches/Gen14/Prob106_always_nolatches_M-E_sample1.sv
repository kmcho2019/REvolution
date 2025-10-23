module TopModule(
    input  [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

reg [3:0] lut [65536:0]; // 16-bit scancode, 4-bit output

initial begin
    for (int i = 0; i < 65536; i++) begin
        lut[i] = 4'b0000; // default output values
    end
    lut[16'he06b] = 4'b1000; // left arrow
    lut[16'he072] = 4'b0100; // down arrow
    lut[16'he074] = 4'b0010; // right arrow
    lut[16'he075] = 4'b0001; // up arrow
end

always @(*) begin
    {left, down, right, up} = lut[scancode];
end

endmodule