module TopModule(
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

reg left_int, down_int, right_int, up_int;

always @(*) begin
    left_int = (scancode == 16'he06b)? 1'b1 : 1'b0;
    down_int = (scancode == 16'he072)? 1'b1 : 1'b0;
    right_int = (scancode == 16'he074)? 1'b1 : 1'b0;
    up_int = (scancode == 16'he075)? 1'b1 : 1'b0;
    
    left = left_int;
    down = down_int;
    right = right_int;
    up = up_int;
end

endmodule