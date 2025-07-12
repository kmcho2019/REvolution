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

    // States with implicit direction
    parameter LEFT = 2'b00;
    parameter RIGHT = 2'b01;
    parameter FALL = 2'b10;
    
    reg [1:0] state, next_state;
    reg ground_prev;
    
    // Edge detection for ground signal
    always @(posedge clk, posedge areset) begin
        if (areset) ground_prev <= 1'b1;
        else ground_prev <= ground;
    end
    
    wire ground_falling = ground_prev && !ground;
    wire ground_rising = !ground_prev && ground;
    
    // State transition logic
    always @(*) begin
        case (state)
            LEFT: begin
                if (ground_falling) next_state = FALL;
                else if (bump_left) next_state = RIGHT;  // Priority to right turn
                else next_state = LEFT;
            end
            RIGHT: begin
                if (ground_falling) next_state = FALL;
                else if (bump_right) next_state = LEFT;  // Priority to left turn
                else next_state = RIGHT;
            end
            FALL: begin
                if (ground_rising) next_state = (state == FALL) ? LEFT : state;  // Return to last direction
                else next_state = FALL;
            end
            default: next_state = LEFT;
        endcase
    end
    
    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) state <= LEFT;
        else state <= next_state;
    end
    
    // Output logic - direct state mapping
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL);

endmodule