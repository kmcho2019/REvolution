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

reg [1:0] state; // WALKING (0), FALLING (1), SPLATTERED (2)
reg [4:0] fall_counter; // counter for falling state
reg walking_direction; // 0 for left, 1 for right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // WALKING
        fall_counter <= 5'b0;
        walking_direction <= 1'b0; // walking left
    end else begin
        case (state)
            2'b00: begin // WALKING
                if (!ground) begin
                    state <= 2'b01; // FALLING
                    fall_counter <= 5'b1;
                end else if (dig) begin
                    // No action, already walking
                end else if (bump_left || bump_right) begin
                    walking_direction <= ~walking_direction;
                end
            end
            2'b01: begin // FALLING
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= 2'b10; // SPLATTERED
                    end else begin
                        state <= 2'b00; // WALKING
                    end
                    fall_counter <= 5'b0;
                end else begin
                    fall_counter <= fall_counter + 1'b1;
                end
            end
            2'b10: begin // SPLATTERED
                // Stay in this state forever
            end
        endcase
    end
end

always @* begin
    walk_left = (state == 2'b00 && walking_direction == 1'b0 && state != 2'b10);
    walk_right = (state == 2'b00 && walking_direction == 1'b1 && state != 2'b10);
    aaah = (state == 2'b01 && state != 2'b10);
    digging = (state == 2'b00 && dig && state != 2'b10);
end

endmodule