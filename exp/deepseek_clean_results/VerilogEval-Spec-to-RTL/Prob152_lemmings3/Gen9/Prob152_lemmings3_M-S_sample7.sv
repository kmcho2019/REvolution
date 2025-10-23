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

    // States now encode direction
    parameter LEFT = 2'd0;
    parameter RIGHT = 2'd1;
    parameter FALLING = 2'd2;
    parameter DIGGING = 2'd3;
    
    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        next_state = state;
        
        case (state)
            LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left) begin
                    next_state = RIGHT;
                end
            end
            
            RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_right) begin
                    next_state = LEFT;
                end
            end
            
            FALLING: begin
                if (ground) begin
                    next_state = (state == FALLING) ? LEFT : state; // Return to previous direction
                end
            end
            
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                end
            end
        endcase
    end

    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT; // Start walking left
        end else begin
            state <= next_state;
        end
    end

    // Output logic - direct mapping from states
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

endmodule