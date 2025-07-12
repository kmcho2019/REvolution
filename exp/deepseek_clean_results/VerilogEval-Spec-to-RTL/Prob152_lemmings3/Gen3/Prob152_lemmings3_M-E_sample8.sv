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
    // Main states
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    
    // Direction states
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg [1:0] state, next_state;
    reg direction, next_direction;
    reg ground_prev;
    
    // Edge detection for ground signal
    wire ground_falling_edge = ground_prev & ~ground;
    wire ground_rising_edge = ~ground_prev & ground;
    
    // Priority encoder
    wire should_fall = ground_falling_edge | (~ground & (state == WALK | state == DIG));
    wire should_dig = dig & ground & (state == WALK) & ~should_fall;
    wire should_switch = ((bump_left & ~direction) | (bump_right & direction)) & 
                        (state == WALK) & ~should_fall & ~should_dig;
    
    // State transition logic
    always @(*) begin
        next_state = state;
        next_direction = direction;
        
        case (state)
            WALK: begin
                if (should_fall) begin
                    next_state = FALL;
                end else if (should_dig) begin
                    next_state = DIG;
                end else if (should_switch) begin
                    next_direction = ~direction;
                end
            end
            FALL: begin
                if (ground_rising_edge) begin
                    next_state = WALK;
                end
            end
            DIG: begin
                if (should_fall) begin
                    next_state = FALL;
                end
            end
        endcase
    end
    
    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= LEFT;
            ground_prev <= 1'b1;
        end else begin
            state <= next_state;
            direction <= next_direction;
            ground_prev <= ground;
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);
    
endmodule