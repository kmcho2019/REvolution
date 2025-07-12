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

reg [1:0] state;
reg [1:0] next_state;
reg direction; // 1 for right, 0 for left
reg next_direction;
reg digging_reg;
reg next_digging;

always @(*) begin
    case (state)
        2'b00: begin // walking left
            if (!ground) begin
                next_state = 2'b10; // falling
                next_direction = direction;
                next_digging = digging_reg;
            end else if (dig) begin
                next_state = 2'b11; // digging
                next_direction = direction;
                next_digging = 1'b1;
            end else if (bump_left) begin
                next_state = 2'b01; // walking right
                next_direction = 1'b1;
                next_digging = digging_reg;
            end else if (bump_right) begin
                next_state = 2'b00; // walking left
                next_direction = 1'b0;
                next_digging = digging_reg;
            end else begin
                next_state = 2'b00; // walking left
                next_direction = direction;
                next_digging = digging_reg;
            end
        end
        2'b01: begin // walking right
            if (!ground) begin
                next_state = 2'b10; // falling
                next_direction = direction;
                next_digging = digging_reg;
            end else if (dig) begin
                next_state = 2'b11; // digging
                next_direction = direction;
                next_digging = 1'b1;
            end else if (bump_left) begin
                next_state = 2'b00; // walking left
                next_direction = 1'b0;
                next_digging = digging_reg;
            end else if (bump_right) begin
                next_state = 2'b01; // walking right
                next_direction = 1'b1;
                next_digging = digging_reg;
            end else begin
                next_state = 2'b01; // walking right
                next_direction = direction;
                next_digging = digging_reg;
            end
        end
        2'b10: begin // falling
            if (ground) begin
                next_state = (direction == 1'b0) ? 2'b00 : 2'b01; // resume walking
                next_direction = direction;
                next_digging = digging_reg;
            end else begin
                next_state = 2'b10; // continue falling
                next_direction = direction;
                next_digging = digging_reg;
            end
        end
        2'b11: begin // digging
            if (!ground) begin
                next_state = 2'b10; // falling
                next_direction = direction;
                next_digging = 1'b0;
            end else begin
                next_state = 2'b11; // continue digging
                next_direction = direction;
                next_digging = 1'b1;
            end
        end
        default: begin
            next_state = 2'b00; // default state
            next_direction = 1'b0;
            next_digging = 1'b0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
        direction <= 1'b0;
        digging_reg <= 1'b0;
    end else begin
        state <= next_state;
        direction <= next_direction;
        digging_reg <= next_digging;
    end
end

assign walk_left = (state == 2'b00) && !digging_reg;
assign walk_right = (state == 2'b01) && !digging_reg;
assign aaah = (state == 2'b10);
assign digging = digging_reg;

endmodule