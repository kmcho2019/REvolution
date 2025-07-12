module TopModule(
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

parameter LEFT_SCANCOD = 16'he06b;
parameter DOWN_SCANCOD = 16'he072;
parameter RIGHT_SCANCOD = 16'he074;
parameter UP_SCANCOD = 16'he075;

always @(*) begin
    left = (scancode == LEFT_SCANCOD) ? 1'b1 : 1'b0;
    down = (scancode == DOWN_SCANCOD) ? 1'b1 : 1'b0;
    right = (scancode == RIGHT_SCANCOD) ? 1'b1 : 1'b0;
    up = (scancode == UP_SCANCOD) ? 1'b1 : 1'b0;
end

endmodule