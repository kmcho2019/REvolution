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

reg [1:0] state; // WALKING (0), FALLING (1), DIGGING (2), SPLATTERED (3)
reg [4:0] fall_counter; // counter for falling state
reg walking_direction; // 0 for left, 1 for right
reg dig_flag; // flag to indicate if lemming is digging

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // WALKING
        fall_counter <= 5'b0;
        walking_direction <= 1'b0; // walking left
        dig_flag <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // WALKING
                if (!ground) begin
                    state <= 2'b01; // FALLING
                    fall_counter <= 5'b1;
                end else if (dig && !dig_flag) begin
                    state <= 2'b10; // DIGGING
                    dig_flag <= 1'b1;
                end else if (bump_left || bump_right) begin
                    walking_direction <= ~walking_direction;
                end
            end
            2'b01: begin // FALLING
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= 2'b11; // SPLATTERED
                    end else begin
                        state <= 2'b00; // WALKING
                    end
                    fall_counter <= 5'b0;
                end else begin
                    fall_counter <= fall_counter + 1'b1;
                end
            end
            2'b10: begin // DIGGING
                if (!ground) begin
                    state <= 2'b01; // FALLING
                    fall_counter <= 5'b1;
                    dig_flag <= 1'b0;
                end
            end
            2'b11: begin // SPLATTERED
                // stay in this state forever
            end
        endcase
    end
end

always @* begin
    walk_left = (state == 2'b00 && !dig_flag && walking_direction == 1'b0 && state != 2'b11);
    walk_right = (state == 2'b00 && !dig_flag && walking_direction == 1'b1 && state != 2'b11);
    aaah = (state == 2'b01 && state != 2'b11);
    digging = (state == 2'b10 && state != 2'b11);
end

endmodule