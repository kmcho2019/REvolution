module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [2:0] state; // WALKING_LEFT (0), WALKING_RIGHT (1), FALLING (2), DIGGING (3), SPLATTERED (4)
reg [2:0] next_state;
reg current_direction; // 0 for left, 1 for right
reg [4:0] fall_counter; // counter for falling state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 3'b000; // WALKING_LEFT
        fall_counter <= 5'b0;
        current_direction <= 1'b0; // walking left
    end else begin
        case (state)
            3'b000: begin // WALKING_LEFT
                if (!ground) begin
                    next_state <= 3'b010; // FALLING
                    fall_counter <= 5'b1;
                end else if (dig) begin
                    next_state <= 3'b011; // DIGGING
                end else if (bump_left && bump_right) begin
                    next_state <= 3'b001; // WALKING_RIGHT
                    current_direction <= 1'b1;
                end else if (bump_left) begin
                    next_state <= 3'b001; // WALKING_RIGHT
                    current_direction <= 1'b1;
                end else if (bump_right) begin
                    next_state <= 3'b000; // WALKING_LEFT
                end else begin
                    next_state <= 3'b000;
                end
            end
            3'b001: begin // WALKING_RIGHT
                if (!ground) begin
                    next_state <= 3'b010; // FALLING
                    fall_counter <= 5'b1;
                end else if (dig) begin
                    next_state <= 3'b011; // DIGGING
                end else if (bump_left && bump_right) begin
                    next_state <= 3'b000; // WALKING_LEFT
                    current_direction <= 1'b0;
                end else if (bump_left) begin
                    next_state <= 3'b000; // WALKING_LEFT
                    current_direction <= 1'b0;
                end else if (bump_right) begin
                    next_state <= 3'b001; // WALKING_RIGHT
                end else begin
                    next_state <= 3'b001;
                end
            end
            3'b010: begin // FALLING
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        next_state <= 3'b100; // SPLATTERED
                    end else begin
                        if (current_direction == 1'b0) begin
                            next_state <= 3'b000; // WALKING_LEFT
                        end else begin
                            next_state <= 3'b001; // WALKING_RIGHT
                        end
                    end
                    fall_counter <= 5'b0;
                end else begin
                    fall_counter <= fall_counter + 1'b1;
                    next_state <= 3'b010;
                end
            end
            3'b011: begin // DIGGING
                if (!ground) begin
                    next_state <= 3'b010; // FALLING
                    fall_counter <= 5'b1;
                end else begin
                    next_state <= 3'b011;
                end
            end
            3'b100: begin // SPLATTERED
                next_state <= 3'b100;
            end
        endcase
        state <= next_state;
    end
end

assign walk_left = (state == 3'b000 &&!dig && current_direction == 1'b0) || (state == 3'b010 && current_direction == 1'b0) || (state == 3'b011 && current_direction == 1'b0);
assign walk_right = (state == 3'b001 &&!dig && current_direction == 1'b1) || (state == 3'b010 && current_direction == 1'b1) || (state == 3'b011 && current_direction == 1'b1);
assign aaah = (state == 3'b010) || (state == 3'b011 &&!ground);
assign digging = (state == 3'b011 && ground);

endmodule