module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [1:0] state, next_state;
reg direction; // 1 for right, 0 for left

always @(*) begin
    next_state = state;
    case (state)
        2'b00: begin // walking left
            if (!ground) begin
                next_state = 2'b10;
            end else if (dig) begin
                next_state = 2'b11;
            end else if (bump_left || (bump_right && !bump_left)) begin
                next_state = 2'b01;
            end else if (bump_right && bump_left) begin
                next_state = 2'b01;
            end
        end
        2'b01: begin // walking right
            if (!ground) begin
                next_state = 2'b10;
            end else if (dig) begin
                next_state = 2'b11;
            end else if (bump_right || (bump_left && !bump_right)) begin
                next_state = 2'b00;
            end else if (bump_left && bump_right) begin
                next_state = 2'b00;
            end
        end
        2'b10: begin // falling
            if (ground) begin
                next_state = direction ? 2'b01 : 2'b00;
            end
        end
        2'b11: begin // digging
            if (!ground) begin
                next_state = 2'b10;
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        direction <= 0;
    end else begin
        state <= next_state;
        case (state)
            2'b00: begin
                direction <= 0;
            end
            2'b01: begin
                direction <= 1;
            end
            2'b10: begin
                // keep previous direction
            end
            2'b11: begin
                // keep previous direction
            end
        endcase
    end
end

assign walk_left = (state == 2'b00);
assign walk_right = (state == 2'b01);
assign aaah = (state == 2'b10);
assign digging = (state == 2'b11);

endmodule