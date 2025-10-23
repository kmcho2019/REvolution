module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

wire prefix_ok = (scancode[15:8] == 8'he0);
wire [7:0] keycode = scancode[7:0];

reg [3:0] arrows;

always @(*) begin
    if (prefix_ok) begin
        case (keycode)
            8'h6b: arrows = 4'b1000; // left
            8'h72: arrows = 4'b0100; // down
            8'h74: arrows = 4'b0010; // right
            8'h75: arrows = 4'b0001; // up
            default: arrows = 4'b0000;
        endcase
    end else begin
        arrows = 4'b0000;
    end
end

assign left  = arrows[3];
assign down  = arrows[2];
assign right = arrows[1];
assign up    = arrows[0];

endmodule