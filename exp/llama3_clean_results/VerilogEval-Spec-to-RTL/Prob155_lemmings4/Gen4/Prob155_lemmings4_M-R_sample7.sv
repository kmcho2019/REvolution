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

reg [1:0] state; // WALKING (0), FALLING (1), DIGGING (2)
reg [4:0] fall_counter; // counter for falling state
reg walking_direction; // 0 for left, 1 for right
reg dig_flag; // flag to indicate if lemming is digging
reg splattered; // flag to indicate if lemming has splattered

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // WALKING
        fall_counter <= 5'b0;
        walking_direction <= 1'b0; // walking left
        dig_flag <= 1'b0;
        splattered <= 1'b0;
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
                    // switch direction
                    walking_direction <= ~walking_direction;
                end
            end
            2'b01: begin // FALLING
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        splattered <= 1'b1;
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
        endcase
    end
end

assign walk_left = (!splattered && state == 2'b00 && !dig_flag && walking_direction == 1'b0);
assign walk_right = (!splattered && state == 2'b00 && !dig_flag && walking_direction == 1'b1);
assign aaah = (!splattered && state == 2'b01);
assign digging = (!splattered && state == 2'b10 && dig_flag);

endmodule