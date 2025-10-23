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

enum logic [1:0] {WALKING, FALLING, DIGGING, SPLATTERED} state, next_state;

reg walking_direction;
reg [4:0] fall_counter;

// Walking direction module
always_ff @(posedge clk) begin
    if (bump_left || bump_right) begin
        walking_direction <= ~walking_direction;
    end
end

// Fall counter module
always_ff @(posedge clk) begin
    if (!ground) begin
        fall_counter <= fall_counter + 1'b1;
    end else begin
        fall_counter <= 5'b0;
    end
end

// State machine
always_comb begin
    case (state)
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                // walking direction is handled by the walking direction module
                next_state = WALKING;
            end else begin
                next_state = WALKING;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = WALKING;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
        default: begin
            next_state = WALKING;
        end
    endcase
end

// Update state
always_ff @(posedge clk) begin
    state <= next_state;
end

// Asynchronous reset
always @(posedge areset) begin
    state <= WALKING;
    walking_direction <= 1'b1;
    fall_counter <= 5'b0;
end

// Output logic
always_comb begin
    walk_left = (state == WALKING && walking_direction) || (state == DIGGING && walking_direction);
    walk_right = (state == WALKING && ~walking_direction) || (state == DIGGING && ~walking_direction);
    aaah = state == FALLING;
    digging = state == DIGGING;
end

endmodule