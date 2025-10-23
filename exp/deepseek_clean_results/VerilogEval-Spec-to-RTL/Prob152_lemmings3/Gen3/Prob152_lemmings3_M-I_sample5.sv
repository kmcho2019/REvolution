module TopModule (
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
    // One-hot state encoding
    parameter WALK = 3'b001;
    parameter FALL = 3'b010;
    parameter DIG  = 3'b100;
    
    reg [2:0] state, next_state;
    reg direction, next_direction; // 0=left, 1=right
    wire clk_enable = (state != next_state) || ((state == WALK) && (direction != next_direction));
    
    // Optimized state transition logic with priority ordering
    always @(*) begin
        next_state = state;
        next_direction = direction;
        
        if (state[0]) begin // WALK state
            if (~ground) begin
                next_state = FALL;
            end else if (dig) begin
                next_state = DIG;
            end else if (bump_left && ~direction) begin
                next_direction = 1'b1;
            end else if (bump_right && direction) begin
                next_direction = 1'b0;
            end
        end
        else if (state[1]) begin // FALL state
            if (ground) begin
                next_state = WALK;
            end
        end
        else if (state[2]) begin // DIG state
            if (~ground) begin
                next_state = FALL;
            end
        end
    end
    
    // Clock-gated state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // Start walking left
        end else if (clk_enable) begin
            state <= next_state;
            if (state == WALK) begin
                direction <= next_direction;
            end
        end
    end
    
    // Direct output assignments from state bits
    assign walk_left  = state[0] & ~direction;
    assign walk_right = state[0] & direction;
    assign aaah       = state[1];
    assign digging    = state[2];
    
endmodule