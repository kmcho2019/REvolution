module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State encoding
    parameter LEFT  = 2'b00;
    parameter RIGHT = 2'b01;
    parameter FALL  = 2'b10;
    
    reg [1:0] state, next_state;
    reg last_ground;
    reg bump_left_prev, bump_right_prev;

    // Edge detection for bumps and ground
    wire ground_falling_edge = last_ground && !ground;
    wire bump_left_edge = bump_left && !bump_left_prev;
    wire bump_right_edge = bump_right && !bump_right_prev;

    // State transition logic
    always @(*) begin
        case (state)
            LEFT: begin
                if (ground_falling_edge) 
                    next_state = FALL;
                else if (bump_left_edge)
                    next_state = RIGHT;
                else
                    next_state = LEFT;
            end
            RIGHT: begin
                if (ground_falling_edge)
                    next_state = FALL;
                else if (bump_right_edge)
                    next_state = LEFT;
                else
                    next_state = RIGHT;
            end
            FALL: begin
                if (ground)
                    next_state = (state_history == LEFT) ? LEFT : RIGHT;
                else
                    next_state = FALL;
            end
            default: next_state = LEFT;
        endcase
    end

    // State history (remembers last walking direction during falls)
    reg [1:0] state_history;
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            state_history <= LEFT;
            last_ground <= 1;
            bump_left_prev <= 0;
            bump_right_prev <= 0;
        end else begin
            state <= next_state;
            last_ground <= ground;
            bump_left_prev <= bump_left;
            bump_right_prev <= bump_right;
            
            // Update history only when walking
            if (state != FALL && next_state != FALL)
                state_history <= next_state;
        end
    end

    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL);

endmodule