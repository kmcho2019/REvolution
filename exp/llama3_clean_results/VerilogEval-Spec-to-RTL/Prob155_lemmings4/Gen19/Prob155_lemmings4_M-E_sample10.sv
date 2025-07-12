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
enum logic [2:0] {S_WALKING, S_FALLING, S_DIGGING, S_SPLATTERED} state, next_state;

// Mealy machine for walking direction
reg walking_direction;
always_ff @(posedge clk) begin
    if (bump_left) begin
        walking_direction <= 1'b1;
    end else if (bump_right) begin
        walking_direction <= 1'b0;
    end
end

// Fall counter module
reg [4:0] fall_counter;
always_ff @(posedge clk) begin
    if (!ground) begin
        fall_counter <= fall_counter + 1'b1;
    end else begin
        fall_counter <= 5'b0;
    end
end

// Moore machine for state management
always_comb begin
    case (state)
        S_WALKING: begin
            if (!ground) begin
                next_state = S_FALLING;
            end else if (dig) begin
                next_state = S_DIGGING;
            end else begin
                next_state = S_WALKING;
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
        S_DIGGING: begin
            if (!ground) begin
                next_state = S_FALLING;
            end else begin
                next_state = S_DIGGING;
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

// Update state
always_ff @(posedge clk) begin
    state <= next_state;
end

// Asynchronous reset
always @(posedge areset) begin
    state <= S_WALKING;
    walking_direction <= 1'b1;
    fall_counter <= 5'b0;
end

// Output logic
always_comb begin
    walk_left = (state == S_WALKING && walking_direction) || (state == S_DIGGING && walking_direction);
    walk_right = (state == S_WALKING && ~walking_direction) || (state == S_DIGGING && ~walking_direction);
    aaah = state == S_FALLING;
    digging = state == S_DIGGING;
end

endmodule