module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state; // 2-bit state register
reg prev_direction; // previous direction (0: left, 1: right)

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to IDLE_LEFT state
        prev_direction <= 0; // reset previous direction to left
        walk_left <= 1'b1; // reset walk_left to 1
        walk_right <= 1'b0; // reset walk_right to 0
        aaah <= 1'b0; // reset aaah to 0
    end else begin
        case (state)
            2'b00: begin // IDLE_LEFT state
                if (!ground) begin
                    state <= 2'b11; // transition to FALLING state
                    prev_direction <= 0; // set previous direction to left
                end else if (bump_left || bump_right) begin
                    state <= 2'b01; // transition to IDLE_RIGHT state
                end
            end
            2'b01: begin // IDLE_RIGHT state
                if (!ground) begin
                    state <= 2'b11; // transition to FALLING state
                    prev_direction <= 1; // set previous direction to right
                end else if (bump_left || bump_right) begin
                    state <= 2'b00; // transition to IDLE_LEFT state
                end
            end
            2'b11: begin // FALLING state
                if (ground) begin
                    if (prev_direction == 0) begin
                        state <= 2'b00; // transition to IDLE_LEFT state
                    end else begin
                        state <= 2'b01; // transition to IDLE_RIGHT state
                    end
                end
            end
        endcase
    end
end

always @ (*) begin
    case (state)
        2'b00: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b11: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

endmodule