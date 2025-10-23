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

reg [1:0] state; // 2-bit state register
reg [4:0] fall_counter; // 5-bit counter to count the number of clock cycles the Lemming has been falling

localparam IDLE = 2'b00; // Idle state
localparam WALK_LEFT = 2'b01; // Walking left state
localparam WALK_RIGHT = 2'b10; // Walking right state
localparam FALLING = 2'b11; // Falling state
localparam DIGGING = 2'b00; // Digging state ( reuse IDLE)

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= WALK_LEFT; // Reset the state to WALK_LEFT
        fall_counter <= 5'b0; // Reset the fall counter
    end else begin
        case (state)
            WALK_LEFT: begin
                if (~ground) begin // Ground disappears
                    state <= FALLING; // Transition to FALLING state
                end else if (dig) begin // Digging command
                    state <= DIGGING; // Transition to DIGGING state
                end else if (bump_left) begin // Bumped from left
                    state <= WALK_RIGHT; // Transition to WALK_RIGHT state
                end else if (bump_right) begin // Bumped from right
                    state <= WALK_LEFT; // Transition to WALK_LEFT state
                end
            end
            WALK_RIGHT: begin
                if (~ground) begin // Ground disappears
                    state <= FALLING; // Transition to FALLING state
                end else if (dig) begin // Digging command
                    state <= DIGGING; // Transition to DIGGING state
                end else if (bump_left) begin // Bumped from left
                    state <= WALK_LEFT; // Transition to WALK_LEFT state
                end else if (bump_right) begin // Bumped from right
                    state <= WALK_RIGHT; // Transition to WALK_RIGHT state
                end
            end
            FALLING: begin
                if (ground) begin // Ground reappears
                    if (fall_counter > 5'd20) begin // Lemming has fallen for more than 20 clock cycles
                        state <= 2'b00; // Transition to SPLATTERED state ( reuse IDLE)
                    end else begin
                        if (bump_left) begin // Bumped from left (will not affect the direction)
                            if (state == WALK_LEFT) begin
                                state <= WALK_LEFT; // Keep walking left
                            end else begin
                                state <= WALK_RIGHT; // Keep walking right
                            end
                        end else if (bump_right) begin // Bumped from right (will not affect the direction)
                            if (state == WALK_LEFT) begin
                                state <= WALK_LEFT; // Keep walking left
                            end else begin
                                state <= WALK_RIGHT; // Keep walking right
                            end
                        end else if (state == WALK_LEFT) begin
                            state <= WALK_LEFT; // Keep walking left
                        end else begin
                            state <= WALK_RIGHT; // Keep walking right
                        end
                    end
                    fall_counter <= 5'b0; // Reset the fall counter
                end
                fall_counter <= fall_counter + 1; // Increment the fall counter
            end
            DIGGING: begin
                if (~ground) begin // Ground disappears
                    state <= FALLING; // Transition to FALLING state
                end
            end
            default: begin
                state <= WALK_LEFT; // Default state is WALK_LEFT
            end
        endcase
    end
end

always @(*) begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        default: begin // SPLATTERED state
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule