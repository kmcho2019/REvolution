module TopModule(
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

reg [3:0] lut_out;

// Lookup table to map scancodes to outputs
reg [3:0] lut[4] = {
    4'b1000, // left arrow
    4'b0100, // down arrow
    4'b0010, // right arrow
    4'b0001  // up arrow
};

reg [15:0] lut_scancodes[4] = {
    16'he06b, // left arrow
    16'he072, // down arrow
    16'he074, // right arrow
    16'he075  // up arrow
};

always @(*) begin
    reg [3:0] default_out = 4'b0000;
    reg [15:0] i;

    for (i = 0; i < 4; i++) begin
        if (scancode == lut_scancodes[i]) begin
            lut_out = lut[i];
            break;
        end else begin
            lut_out = default_out;
        end
    end

    {left, down, right, up} = lut_out;
end

endmodule