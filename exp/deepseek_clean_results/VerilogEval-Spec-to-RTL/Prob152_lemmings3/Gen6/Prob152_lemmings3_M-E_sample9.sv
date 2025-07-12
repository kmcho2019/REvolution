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
    // Action states
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    
    // Direction states
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg [1:0] action_state, next_action;
    reg direction, next_dir;
    reg ground_prev;
    
    // Falling edge detection for ground
    wire ground_fall = ground_prev & ~ground;
    
    // Next action state logic
    always @(*) begin
        next_action = action_state;
        case (action_state)
            WALK: begin
                if (ground_fall) begin
                    next_action = FALL;
                end else if (ground && dig) begin
                    next_action = DIG;
                end
            end
            FALL: begin
                if (ground) begin
                    next_action = WALK;
                end
            end
            DIG: begin
                if (ground_fall) begin
                    next_action = FALL;
                end
            end
        endcase
    end
    
    // Next direction logic (only changes when walking)
    always @(*) begin
        next_dir = direction;
        if (action_state == WALK && next_action == WALK) begin
            if (bump_left && direction == LEFT) begin
                next_dir = RIGHT;
            end else if (bump_right && direction == RIGHT) begin
                next_dir = LEFT;
            end
        end
    end
    
    // State registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            action_state <= WALK;
            direction <= LEFT;
            ground_prev <= 1'b1;
        end else begin
            action_state <= next_action;
            direction <= next_dir;
            ground_prev <= ground;
        end
    end
    
    // Registered outputs
    reg r_walk_left, r_walk_right, r_aaah, r_digging;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            r_walk_left <= 1'b1;
            r_walk_right <= 1'b0;
            r_aaah <= 1'b0;
            r_digging <= 1'b0;
        end else begin
            r_walk_left <= (next_action == WALK) && (next_dir == LEFT);
            r_walk_right <= (next_action == WALK) && (next_dir == RIGHT);
            r_aaah <= (next_action == FALL);
            r_digging <= (next_action == DIG);
        end
    end
    
    assign walk_left = r_walk_left;
    assign walk_right = r_walk_right;
    assign aaah = r_aaah;
    assign digging = r_digging;
    
endmodule