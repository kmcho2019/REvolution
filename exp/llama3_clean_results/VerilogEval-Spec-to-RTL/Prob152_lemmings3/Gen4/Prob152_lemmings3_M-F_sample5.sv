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

// Define the states
localparam IDLE_LEFT = 2'b00;
localparam IDLE_RIGHT = 2'b01;
localparam FALLING = 2'b10;
localparam DIGGING = 2'b11;

reg [1:0] state, next_state;
reg [1:0] previous_walking_state; // Store the previous walking state (IDLE_LEFT or IDLE_RIGHT) before falling

// Determine the next state
always_comb begin
    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end else begin
                next_state = IDLE_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                // If the previous walking state was IDLE_LEFT, go back to IDLE_LEFT, otherwise go back to IDLE_RIGHT
                if (previous_walking_state == IDLE_LEFT) begin
                    next_state = IDLE_LEFT;
                end else if (previous_walking_state == IDLE_RIGHT) begin
                    next_state = IDLE_RIGHT;
                end else begin
                    next_state = IDLE_LEFT; // Default to IDLE_LEFT
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
    endcase
end

// Update the state, previous walking state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        previous_walking_state <= IDLE_LEFT;
    end else begin
        state <= next_state;
        if ((state == IDLE_LEFT || state == IDLE_RIGHT) && !ground) begin
            previous_walking_state <= state; // Update the previous walking state when falling
        end
    end
end

// Determine the output signals
always_comb begin
    case (state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        IDLE_RIGHT: begin
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
    endcase
end

endmodule