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

reg [2:0] state; // 0: WALKING_LEFT, 1: WALKING_RIGHT, 2: FALLING, 3: DIGGING, 4: SPLATTERED
reg previous_direction; // 0: WALKING_LEFT, 1: WALKING_RIGHT
reg [4:0] fall_counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // WALKING_LEFT
        previous_direction <= 0; // WALKING_LEFT
        fall_counter <= 5'b0;
    end else begin
        case (state)
            0: begin // WALKING_LEFT
                if (~ground) begin
                    state <= 2; // FALLING
                    previous_direction <= 0; // WALKING_LEFT
                end else if (dig) begin
                    state <= 3; // DIGGING
                end else if (bump_left) begin
                    state <= 1; // WALKING_RIGHT
                end else if (bump_right) begin
                    state <= 1; // WALKING_RIGHT
                end
            end
            1: begin // WALKING_RIGHT
                if (~ground) begin
                    state <= 2; // FALLING
                    previous_direction <= 1; // WALKING_RIGHT
                end else if (dig) begin
                    state <= 3; // DIGGING
                end else if (bump_right) begin
                    state <= 0; // WALKING_LEFT
                end else if (bump_left) begin
                    state <= 0; // WALKING_LEFT
                end
            end
            2: begin // FALLING
                if (~ground) begin
                    fall_counter <= fall_counter + 1'b1;
                end else begin
                    if (fall_counter > 5'd20) begin
                        state <= 4; // SPLATTERED
                    end else begin
                        if (previous_direction == 0) begin
                            state <= 0; // WALKING_LEFT
                        end else begin
                            state <= 1; // WALKING_RIGHT
                        end
                    end
                    fall_counter <= 5'b0;
                end
            end
            3: begin // DIGGING
                if (~ground) begin
                    state <= 2; // FALLING
                    previous_direction <= state == 0 ? 0 : 1; // WALKING_LEFT or WALKING_RIGHT
                end
            end
            4: begin // SPLATTERED
                // Stay in this state
            end
        endcase
    end
end

assign walk_left = (state == 0) && (ground);
assign walk_right = (state == 1) && (ground);
assign aaah = (state == 2);
assign digging = (state == 3);

endmodule