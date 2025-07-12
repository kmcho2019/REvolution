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
    // Efficient state encoding
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    
    reg [1:0] state, next_state;
    reg direction, next_direction; // 0=left, 1=right
    
    // Optimized state transition logic
    always @(*) begin
        next_state = state;
        next_direction = direction;
        
        case (state)
            WALK: begin
                if (~ground) begin
                    next_state = FALL; // Highest priority: fall
                end else if (dig) begin
                    next_state = DIG;  // Medium priority: dig
                end else if (bump_left && ~direction) begin
                    next_direction = 1'b1; // Change to right
                end else if (bump_right && direction) begin
                    next_direction = 1'b0; // Change to left
                end
            end
            
            FALL: begin
                if (ground) begin
                    next_state = WALK; // Return to walking when ground returns
                end
            end
            
            DIG: begin
                if (~ground) begin
                    next_state = FALL; // Start falling when ground disappears
                end
            end
        endcase
    end
    
    // State register with optimized updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // Start walking left
        end else begin
            state <= next_state;
            // Only update direction in WALK state to reduce power
            if (state == WALK) begin
                direction <= next_direction;
            end
        end
    end
    
    // Minimal output logic
    assign walk_left  = (state == WALK) && ~direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);
    
endmodule