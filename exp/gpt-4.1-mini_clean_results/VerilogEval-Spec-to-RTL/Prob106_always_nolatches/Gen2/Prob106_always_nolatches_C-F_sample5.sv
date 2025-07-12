module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

wire prefix_ok = (scancode[15:8] == 8'he0);
wire [7:0] keycode = scancode[7:0];

reg [3:0] dir;

always @(*) begin
    if (prefix_ok) begin
        case (keycode)
            8'h6b: dir = 4'b1000; // left
            8'h72: dir = 4'b0100; // down
            8'h74: dir = 4'b0010; // right
            8'h75: dir = 4'b0001; // up
            default: dir = 4'b0000;
        endcase
    end else begin
        dir = 4'b0000;
    end
end

assign left  = dir[3];
assign down  = dir[2];
assign right = dir[1];
assign up    = dir[0];

endmodule