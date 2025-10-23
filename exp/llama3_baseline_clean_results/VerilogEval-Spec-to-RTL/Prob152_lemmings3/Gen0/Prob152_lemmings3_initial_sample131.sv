module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [1:0] state, next_state;
reg direction;

localparam WL = 2'b00;  // walking left
localparam WR = 2'b01;  // walking right
localparam F = 2'b10;   // falling
localparam D = 2'b11;   // digging

always @(*) begin
    next_state = state;
    case (state)
        WL: begin
            if (~ground) next_state = F;
            else if (dig) next_state = D;
            else if (bump_left) next_state = WR;
            else if (bump_right) next_state = WL;
        end
        WR: begin
            if (~ground) next_state = F;
            else if (dig) next_state = D;
            else if (bump_left) next_state = WL;
            else if (bump_right) next_state = WR;
        end
        F: begin
            if (ground) begin
                if (direction) next_state = WL;
                else next_state = WR;
            end
        end
        D: begin
            if (~ground) next_state = F;
            else next_state = D;
        end
        default: next_state = WL;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WL;
        direction <= 1'b1;  // initial direction is left
    end else begin
        state <= next_state;
        if (state == WL || state == D) direction <= 1'b1;
        else if (state == WR) direction <= 1'b0;
    end
end

assign walk_left = (state == WL) || ((state == F || state == D) && direction);
assign walk_right = (state == WR) || ((state == F || state == D) && ~direction);
assign aaah = (state == F);
assign digging = (state == D);

endmodule