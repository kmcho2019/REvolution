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

// Define states
enum logic [1:0] {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING} state, nextState;

// Define direction
logic [0:0] direction;

// Initialize walk_left and walk_right
assign walk_left = (state == IDLE_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (state == IDLE_RIGHT) ? 1'b1 : 1'b0;

// Initialize aaah and digging
assign aaah = (state == FALLING) ? 1'b1 : 1'b0;
assign digging = (state == DIGGING) ? 1'b1 : 1'b0;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        direction <= 1'b0;
    end else begin
        state <= nextState;
        if ((bump_left && bump_right) || (state == FALLING && ground) || (state == DIGGING && !ground)) begin
            // Toggle direction
            direction <= ~direction;
        end
    end
end

// Combinational logic for next state
always_comb begin
    // Default next state is current state
    nextState = state;

    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                // Start falling
                nextState = FALLING;
            end else if (dig && ground) begin
                // Start digging
                nextState = DIGGING;
            end else if (bump_right) begin
                // Switch direction
                nextState = IDLE_RIGHT;
            end else if (bump_left) begin
                // Do nothing
            end
        end

        IDLE_RIGHT: begin
            if (!ground) begin
                // Start falling
                nextState = FALLING;
            end else if (dig && ground) begin
                // Start digging
                nextState = DIGGING;
            end else if (bump_left) begin
                // Switch direction
                nextState = IDLE_LEFT;
            end else if (bump_right) begin
                // Do nothing
            end
        end

        FALLING: begin
            if (ground) begin
                // Stop falling and resume walking
                if (direction) begin
                    nextState = IDLE_LEFT;
                end else begin
                    nextState = IDLE_RIGHT;
                end
            end
        end

        DIGGING: begin
            if (!ground) begin
                // Stop digging and start falling
                nextState = FALLING;
            end
        end

        default: begin
            // Default next state is IDLE_LEFT
            nextState = IDLE_LEFT;
        end
    endcase
end

endmodule