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

// Define the top-level states
enum logic [1:0] {
    WALKING_STATE = 2'b00,
    FALLING_STATE = 2'b01,
    DIGGING_STATE = 2'b10,
    SPLATTERED_STATE = 2'b11
} top_level_state, next_top_level_state;

// Define the walking direction
reg walking_direction;

// Define the fall counter
reg [4:0] fall_counter;

// Update the top-level state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        top_level_state <= WALKING_STATE;
        walking_direction <= 1'b0;
        fall_counter <= 5'b0;
    end else begin
        top_level_state <= next_top_level_state;
        if (next_top_level_state == WALKING_STATE) begin
            walking_direction <= (bump_left || bump_right)? ~walking_direction : walking_direction;
        end
        if (top_level_state == FALLING_STATE) begin
            fall_counter <= fall_counter + 1'b1;
        end else begin
            fall_counter <= 5'b0;
        end
    end
end

// Calculate the next top-level state
always @(*) begin
    case (top_level_state)
        WALKING_STATE: begin
            if (!ground) begin
                next_top_level_state = FALLING_STATE;
            end else if (dig) begin
                next_top_level_state = DIGGING_STATE;
            end else begin
                next_top_level_state = WALKING_STATE;
            end
        end
        FALLING_STATE: begin
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_top_level_state = SPLATTERED_STATE;
                end else begin
                    next_top_level_state = WALKING_STATE;
                end
            end else begin
                next_top_level_state = FALLING_STATE;
            end
        end
        DIGGING_STATE: begin
            if (!ground) begin
                next_top_level_state = FALLING_STATE;
            end else if (!dig) begin
                next_top_level_state = WALKING_STATE;
            end else begin
                next_top_level_state = DIGGING_STATE;
            end
        end
        SPLATTERED_STATE: begin
            next_top_level_state = SPLATTERED_STATE;
        end
    endcase
end

// Assign the outputs
always @(*) begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    case (top_level_state)
        WALKING_STATE: begin
            if (walking_direction == 1'b0) begin
                walk_left = 1'b1;
            end else begin
                walk_right = 1'b1;
            end
        end
        FALLING_STATE: begin
            aaah = 1'b1;
        end
        DIGGING_STATE: begin
            digging = 1'b1;
        end
        SPLATTERED_STATE: begin
            // Do nothing
        end
    endcase
end

endmodule