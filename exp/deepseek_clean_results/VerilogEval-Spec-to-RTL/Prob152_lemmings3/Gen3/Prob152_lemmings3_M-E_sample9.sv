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
    // Gray-coded state encoding
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALL = 2'b11;
    parameter DIG = 2'b10;
    
    reg [1:0] state, next_state;
    reg [1:0] bump_queue; // [0] = left bump pending, [1] = right bump pending
    
    // State transition logic
    always @(*) begin
        next_state = state;
        
        case (state)
            WALK_LEFT, WALK_RIGHT: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else begin
                    // Process queued bumps first
                    if (bump_queue[0]) begin
                        next_state = WALK_RIGHT;
                        bump_queue[0] = 1'b0;
                    end else if (bump_queue[1]) begin
                        next_state = WALK_LEFT;
                        bump_queue[1] = 1'b0;
                    // Then process current bumps
                    end else if ((state == WALK_LEFT && bump_left) || 
                               (state == WALK_RIGHT && bump_right)) begin
                        next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
                    end
                end
            end
            
            FALL: begin
                if (ground) begin
                    next_state = (bump_queue[0]) ? WALK_RIGHT : 
                                (bump_queue[1]) ? WALK_LEFT : 
                                (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
                    bump_queue = 2'b00;
                end
            end
            
            DIG: begin
                if (~ground) begin
                    next_state = FALL;
                end
            end
        endcase
    end
    
    // Bump event queue
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            bump_queue <= 2'b00;
        end else begin
            if (state != WALK_LEFT && state != WALK_RIGHT) begin
                if (bump_left) bump_queue[0] <= 1'b1;
                if (bump_right) bump_queue[1] <= 1'b1;
            end
        end
    end
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end
    
    // Output logic - direct state decoding
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);
    
endmodule