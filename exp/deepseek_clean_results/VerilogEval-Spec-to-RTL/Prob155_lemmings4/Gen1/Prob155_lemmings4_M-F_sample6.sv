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

    // Define states
    parameter WALK_LEFT = 3'd0;
    parameter WALK_RIGHT = 3'd1;
    parameter FALLING = 3'd2;
    parameter DIGGING = 3'd3;
    parameter SPLATTERED = 3'd4;
    
    reg [2:0] state, next_state;
    reg [4:0] fall_counter;
    reg walking_left;  // Stores walking direction before fall/dig
    
    // State transition logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 5'd20)
                        next_state = SPLATTERED;
                    else
                        next_state = walking_left ? WALK_LEFT : WALK_RIGHT;
                end
                else
                    next_state = FALLING;
            end
            DIGGING: begin
                if (!ground)
                    next_state = FALLING;
                else
                    next_state = DIGGING;
            end
            SPLATTERED: begin
                next_state = SPLATTERED;
            end
            default: next_state = WALK_LEFT;
        endcase
    end
    
    // State register, direction storage, and fall counter
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walking_left <= 1;
            fall_counter <= 0;
        end
        else begin
            state <= next_state;
            
            // Store walking direction when leaving walking states
            if ((state == WALK_LEFT || state == WALK_RIGHT) && 
                (next_state == FALLING || next_state == DIGGING)) begin
                walking_left <= (state == WALK_LEFT);
            end
            
            // Update fall counter
            if (state == FALLING) begin
                if (!ground)
                    fall_counter <= fall_counter + 1;
                else
                    fall_counter <= 0;
            end
            else begin
                fall_counter <= 0;
            end
        end
    end
    
    // Output logic (Moore style)
    assign walk_left = (state == WALK_LEFT) && (state != SPLATTERED);
    assign walk_right = (state == WALK_RIGHT) && (state != SPLATTERED);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);
    
endmodule