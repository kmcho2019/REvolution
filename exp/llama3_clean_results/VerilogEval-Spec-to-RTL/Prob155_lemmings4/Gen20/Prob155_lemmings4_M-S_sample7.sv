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

// One-hot encoding scheme for the state machine
enum logic [1:0] {S_WALKING, S_FALLING, S_SPLATTERED} state, next_state;

// Flags to indicate the Lemming's activity
reg walking_direction;
reg [4:0] fall_counter;

// State machine logic
always_comb begin
    case (state)
        S_WALKING: begin
            if (!ground) begin
                next_state = S_FALLING;
            end else if (dig && ground) begin
                next_state = S_WALKING;
                walking_direction <= walking_direction;
                digging <= 1'b1;
            end else begin
                next_state = S_WALKING;
                walking_direction <= bump_left ? 1'b1 : (bump_right ? 1'b0 : walking_direction);
                digging <= 1'b0;
            end
        end
        S_FALLING: begin
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = S_SPLATTERED;
                end else begin
                    next_state = S_WALKING;
                end
            end else begin
                next_state = S_FALLING;
            end
        end
        S_SPLATTERED: begin
            next_state = S_SPLATTERED;
        end
        default: begin
            next_state = S_WALKING;
        end
    endcase
end

// Update state and flags
always_ff @(posedge clk) begin
    if (areset) begin
        state <= S_WALKING;
        walking_direction <= 1'b1;
        fall_counter <= 5'b0;
        digging <= 1'b0;
    end else begin
        state <= next_state;
        if (state == S_FALLING) begin
            fall_counter <= fall_counter + 1'b1;
        end else begin
            fall_counter <= 5'b0;
        end
    end
end

// Output logic
always_comb begin
    walk_left = (state == S_WALKING && walking_direction && !digging) || (state == S_WALKING && walking_direction && digging);
    walk_right = (state == S_WALKING && ~walking_direction && !digging) || (state == S_WALKING && ~walking_direction && digging);
    aaah = state == S_FALLING;
    digging = (state == S_WALKING && digging);
end

endmodule