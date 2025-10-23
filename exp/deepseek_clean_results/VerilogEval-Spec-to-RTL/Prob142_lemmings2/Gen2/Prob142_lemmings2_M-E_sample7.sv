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
    localparam WALK_LEFT = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING = 2'b10;
    
    reg [1:0] state, next_state;
    reg prev_ground;
    reg bump_left_prev, bump_right_prev;
    
    // Register inputs for edge detection
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            prev_ground <= 1;
            bump_left_prev <= 0;
            bump_right_prev <= 0;
        end else begin
            prev_ground <= ground;
            bump_left_prev <= bump_left;
            bump_right_prev <= bump_right;
        end
    end
    
    // Detect ground transitions
    wire ground_falling = prev_ground && !ground;
    wire ground_rising = !prev_ground && ground;
    
    // Detect bump edges
    wire bump_left_edge = bump_left && !bump_left_prev;
    wire bump_right_edge = bump_right && !bump_right_prev;
    
    // State transition logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (ground_falling) begin
                    next_state = FALLING;
                end else if (bump_left_edge) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (ground_falling) begin
                    next_state = FALLING;
                end else if (bump_right_edge) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground_rising) begin
                    // Return to previous walking direction
                    next_state = (bump_left_prev) ? WALK_RIGHT : 
                                (bump_right_prev) ? WALK_LEFT : state;
                end else begin
                    next_state = FALLING;
                end
            end
            default: next_state = WALK_LEFT;
        endcase
    end
    
    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALLING);

endmodule