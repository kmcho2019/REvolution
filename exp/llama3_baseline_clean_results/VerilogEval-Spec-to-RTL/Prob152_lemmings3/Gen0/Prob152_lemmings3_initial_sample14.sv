module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [1:0] state;
reg [1:0] next_state;
reg original_direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        original_direction <= 1'b0;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // walking left
            if (!ground) begin
                next_state = 2'b10;
            end else if (dig && ground) begin
                next_state = 2'b11;
                original_direction = 1'b0;
            end else if (bump_right) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin // walking right
            if (!ground) begin
                next_state = 2'b10;
            end else if (dig && ground) begin
                next_state = 2'b11;
                original_direction = 1'b1;
            end else if (bump_left) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b01;
            end
        end
        2'b10: begin // falling
            if (ground) begin
                if (original_direction == 1'b0) begin
                    next_state = 2'b00;
                end else begin
                    next_state = 2'b01;
                end
            end else begin
                next_state = 2'b10;
            end
        end
        2'b11: begin // digging
            if (!ground) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b11;
            end
        end
    endcase
end

always @(*) begin
    case (state)
        2'b00: begin // walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b01: begin // walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b10: begin // falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        2'b11: begin // digging
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
    endcase
end

endmodule