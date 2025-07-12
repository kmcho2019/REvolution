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

    // Explicit state encoding
    parameter [1:0] WALK = 2'b00;
    parameter [1:0] DIG  = 2'b01;
    parameter [1:0] FALL = 2'b10;
    
    reg [1:0] state, next_state;
    reg direction, next_direction;
    
    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0; // Start walking left
        end
        else begin
            state <= next_state;
            direction <= next_direction;
        end
    end
    
    // Next state and direction logic
    always @(*) begin
        // Default to current state and direction
        next_state = state;
        next_direction = direction;
        
        case (state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                end
                else if (dig) begin
                    next_state = DIG;
                end
                else begin
                    // Handle direction changes only when walking normally
                    if (bump_left) next_direction = 1'b1;
                    else if (bump_right) next_direction = 1'b0;
                end
            end
            
            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                end
                else if (!dig) begin
                    next_state = WALK;
                end
            end
            
            FALL: begin
                if (ground) begin
                    next_state = WALK;
                end
            end
        endcase
    end
    
    // Output logic
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);
    
endmodule