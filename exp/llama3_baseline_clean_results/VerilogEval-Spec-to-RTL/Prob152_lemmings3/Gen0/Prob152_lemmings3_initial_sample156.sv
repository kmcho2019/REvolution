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

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling, 3: digging
reg [1:0] next_state;

always @(*) begin
    case (state)
        2'b00: begin // walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            if (!ground) begin
                next_state = 2'b10; // falling
            end else if (dig) begin
                next_state = 2'b11; // digging
            end else if (bump_left) begin
                next_state = 2'b01; // walking right
            end else if (bump_right) begin
                next_state = 2'b00; // walking left
            end else begin
                next_state = 2'b00; // walking left
            end
        end
        2'b01: begin // walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            if (!ground) begin
                next_state = 2'b10; // falling
            end else if (dig) begin
                next_state = 2'b11; // digging
            end else if (bump_left) begin
                next_state = 2'b00; // walking left
            end else if (bump_right) begin
                next_state = 2'b01; // walking right
            end else begin
                next_state = 2'b01; // walking right
            end
        end
        2'b10: begin // falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            if (ground) begin
                if (state == 2'b10) begin
                    if (bump_left || bump_right) begin
                        if (bump_left) begin
                            next_state = 2'b01; // walking right
                        end else begin
                            next_state = 2'b00; // walking left
                        end
                    end else if (state == 2'b10) begin
                        if (bump_left) begin
                            next_state = 2'b01; // walking right
                        end else if (bump_right) begin
                            next_state = 2'b00; // walking left
                        end else begin
                            if (dig) begin
                                next_state = 2'b11; // digging
                            end else begin
                                next_state = state; // resume walking
                            end
                        end
                    end
                end
            end else begin
                next_state = 2'b10; // falling
            end
        end
        2'b11: begin // digging
            walk_left = 1'b0;
            walk_right = 1'b0;
            digging = 1'b1;
            if (!ground) begin
                next_state = 2'b10; // falling
            end else begin
                next_state = 2'b11; // digging
            end
        end
        default: next_state = 2'b00; // walking left
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // walking left
    end else begin
        state <= next_state;
    end
end

assign aaah = (state == 2'b10) ? 1'b1 : 1'b0;
assign digging = (state == 2'b11) ? 1'b1 : 1'b0;

endmodule