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

reg [2:0] state; // WALKING (0), FALLING (1), DIGGING (2), SPLATTERED (3)
reg [4:0] fall_counter; // counter for falling state
reg walking_direction; // 0 for left, 1 for right
reg digging_flag; // flag to indicate if lemming is digging

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 3'b000; // WALKING
        fall_counter <= 5'b0;
        walking_direction <= 1'b0; // walking left
        digging_flag <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // WALKING
                if (~ground) begin
                    state <= 3'b001; // FALLING
                    fall_counter <= 5'b1;
                end else if (dig && !digging_flag) begin
                    state <= 3'b010; // DIGGING
                    digging_flag <= 1'b1;
                end else if (bump_left || bump_right) begin
                    // switch direction
                    if (walking_direction == 1'b0) begin
                        walking_direction <= 1'b1; // walking right
                    end else begin
                        walking_direction <= 1'b0; // walking left
                    end
                end
            end
            3'b001: begin // FALLING
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= 3'b011; // SPLATTERED
                    end else begin
                        state <= 3'b000; // WALKING
                    end
                    fall_counter <= 5'b0;
                end else begin
                    fall_counter <= fall_counter + 1'b1;
                end
            end
            3'b010: begin // DIGGING
                if (~ground) begin
                    state <= 3'b001; // FALLING
                    fall_counter <= 5'b1;
                    digging_flag <= 1'b0;
                end
            end
            3'b011: begin // SPLATTERED
                // do nothing
            end
        endcase
    end
end

always @(*) begin
    walk_left = (state == 3'b000 && walking_direction == 1'b0 && !digging_flag);
    walk_right = (state == 3'b000 && walking_direction == 1'b1 && !digging_flag);
    aaah = (state == 3'b001);
    digging = (state == 3'b010 && digging_flag);
end

endmodule