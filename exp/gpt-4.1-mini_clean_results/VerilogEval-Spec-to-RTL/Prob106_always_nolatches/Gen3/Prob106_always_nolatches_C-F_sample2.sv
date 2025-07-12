module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

    wire prefix_match = (scancode[15:8] == 8'hE0);
    wire [7:0] keycode = scancode[7:0];
    reg [3:0] arrows;

    always @(*) begin
        arrows = 4'b0000;
        if (prefix_match) begin
            case (keycode)
                8'h6B: arrows = 4'b1000; // left
                8'h72: arrows = 4'b0100; // down
                8'h74: arrows = 4'b0010; // right
                8'h75: arrows = 4'b0001; // up
                default: arrows = 4'b0000;
            endcase
        end
    end

    assign {left, down, right, up} = arrows;

endmodule