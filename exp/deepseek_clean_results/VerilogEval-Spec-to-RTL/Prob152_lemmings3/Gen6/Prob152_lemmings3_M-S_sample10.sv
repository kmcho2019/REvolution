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
    parameter LEFT  = 2'b00;
    parameter RIGHT = 2'b01;
    parameter FALL  = 2'b10;
    
    reg [1:0] state, next_state;
    
    always @(*) begin
        case (state)
            LEFT: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = LEFT; // Stay in LEFT but digging=1
                end else if (bump_left) begin
                    next_state = RIGHT;
                end else begin
                    next_state = LEFT;
                end
            end
            
            RIGHT: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = RIGHT; // Stay in RIGHT but digging=1
                end else if (bump_right) begin
                    next_state = LEFT;
                end else begin
                    next_state = RIGHT;
                end
            end
            
            FALL: begin
                if (ground) begin
                    // Return to previous walking state
                    next_state = (state == LEFT) ? LEFT : RIGHT;
                end else begin
                    next_state = FALL;
                end
            end
            
            default: next_state = LEFT;
        endcase
    end
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end else begin
            state <= next_state;
        end
    end
    
    assign walk_left  = (state == LEFT) && ground && ~dig;
    assign walk_right = (state == RIGHT) && ground && ~dig;
    assign aaah       = (state == FALL);
    assign digging    = ((state == LEFT) || (state == RIGHT)) && ground && dig;
    
endmodule