module TopModule(
    input  wire [15:0] scancode,
    output reg         left,
    output reg         down,
    output reg         right,
    output reg         up
);

parameter LEFT_SCANCODE  = 16'he06b;
parameter DOWN_SCANCODE  = 16'he072;
parameter RIGHT_SCANCODE  = 16'he074;
parameter UP_SCANCODE     = 16'he075;

always @(*) begin
    left  = (scancode == LEFT_SCANCODE) ? 1'b1 : 1'b0;
    down  = (scancode == DOWN_SCANCODE) ? 1'b1 : 1'b0;
    right = (scancode == RIGHT_SCANCODE)? 1'b1 : 1'b0;
    up    = (scancode == UP_SCANCODE)    ? 1'b1 : 1'b0;
end

endmodule