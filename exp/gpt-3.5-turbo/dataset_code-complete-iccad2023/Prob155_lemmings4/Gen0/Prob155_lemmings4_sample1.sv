module LemmingsFSM (
    input clk, areset, bump_left, bump_right, ground, dig,
    output walk_left, walk_right, aaah, digging
);

    // Define state encoding
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    parameter DIGGING = 2'b11;
    parameter SPLATTER = 2'b10;
    
    // Define state registers
    reg [1:0] state, next_state;
    
    // Define outputs
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);
    
    // Define splatter counter
    reg [4:0] splatter_counter;
    
    // Moore state machine logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            splatter_counter <= 0;
        end
        else begin
            state <= next_state;
        end
    end

    always @* begin
        next_state = state;
        
        case (state)
            WALK_LEFT: begin
                if (bump_left || dig)
                    next_state = WALK_RIGHT;
                else if (ground == 0)
                    next_state = FALLING;
            end
            WALK_RIGHT: begin
                if (bump_right || dig)
                    next_state = WALK_LEFT;
                else if (ground == 0)
                    next_state = FALLING;
            end
            FALLING: begin
                if (ground == 1)
                    next_state = state; // Resume walking in same direction

                if (splatter_counter < 20)
                    splatter_counter <= splatter_counter + 1;
                else
                    next_state = SPLATTER;
            end
            DIGGING: begin
                if (ground == 0)
                    next_state = FALLING;
            end
            SPLATTER: begin
                // Stay in splatter state indefinitely
            end
        endcase
    end

endmodule