module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
enum logic [1:0] {
    WALKING,
    FALLING,
    DIGGING
} state, next_state;

// Define the walking direction
reg walk_direction;
reg next_walk_direction;

// Mode signal
reg mode;
reg next_mode;

// Previous state tracking
reg [1:0] prev_state;
reg [1:0] next_prev_state;

// One-hot encoding for states
reg [2:0] state_hot;
reg [2:0] next_state_hot;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_direction <= 0; // left
        mode <= 0;
        prev_state <= WALKING;
        state_hot <= 3'b001;
    end else begin
        state <= next_state;
        walk_direction <= next_walk_direction;
        mode <= next_mode;
        prev_state <= next_prev_state;
        state_hot <= next_state_hot;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    next_walk_direction = walk_direction;
    next_mode = mode;
    next_prev_state = prev_state;
    next_state_hot = state_hot;
    
    case (state)
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
                next_state_hot = 3'b010;
            end else if (dig) begin
                next_state = DIGGING;
                next_state_hot = 3'b100;
            end else if (bump_left) begin
                next_walk_direction = 1; // right
            end else if (bump_right) begin
                next_walk_direction = 0; // left
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = WALKING;
                next_state_hot = 3'b001;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
                next_state_hot = 3'b010;
            end
        end
    endcase
    
    // Update mode
    if (state == WALKING && dig) begin
        next_mode = 1;
    end else if (state == DIGGING && !ground) begin
        next_mode = 0;
    end
    
    // Update previous state
    next_prev_state = state;
end

// Output logic
assign walk_left = (state_hot[0] && !walk_direction) ? 1'b1 : 1'b0;
assign walk_right = (state_hot[0] && walk_direction) ? 1'b1 : 1'b0;
assign aaah = (state_hot[1]) ? 1'b1 : 1'b0;
assign digging = (state_hot[2]) ? 1'b1 : 1'b0;

endmodule