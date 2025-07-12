module TopModule (
    input  wire [15:0] scancode,
    output reg         left,
    output reg         down,
    output reg         right,
    output reg         up
);

    reg [3:0] lut_left;
    reg [3:0] lut_down;
    reg [3:0] lut_right;
    reg [3:0] lut_up;

    always @(*) begin
        case (scancode)
            16'he06b: begin lut_left = 4'b0001; lut_down = 4'b0000; lut_right = 4'b0000; lut_up = 4'b0000; end
            16'he072: begin lut_left = 4'b0000; lut_down = 4'b0001; lut_right = 4'b0000; lut_up = 4'b0000; end
            16'he074: begin lut_left = 4'b0000; lut_down = 4'b0000; lut_right = 4'b0001; lut_up = 4'b0000; end
            16'he075: begin lut_left = 4'b0000; lut_down = 4'b0000; lut_right = 4'b0000; lut_up = 4'b0001; end
            default: begin lut_left = 4'b0000; lut_down = 4'b0000; lut_right = 4'b0000; lut_up = 4'b0000; end
        endcase

        left  = lut_left[0];
        down = lut_down[0];
        right = lut_right[0];
        up   = lut_up[0];
    end

endmodule