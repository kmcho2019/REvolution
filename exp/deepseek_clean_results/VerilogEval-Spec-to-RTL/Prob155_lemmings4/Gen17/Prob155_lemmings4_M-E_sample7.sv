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

    // Primary state encoding
    parameter WALKING = 2'b00;
    parameter DIGGING = 2'b01;
    parameter FALLING = 2'b10;
    parameter SPLATTER = 2'b11;
    
    // Direction state
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg [1:0] state;
    reg [1:0] next_state;
    reg direction;          // Current walking direction
    reg saved_direction;    // Saved direction during non-walking states
    reg [4:0] fall_timer;  // 5-bit counter for fall duration
    
    // Event priority encoder
    wire fall_condition = !ground && (state == WALKING || state == DIGGING);
    wire dig_condition = ground && dig && state == WALKING;
    wire bump_condition = (state == WALKING) && 
                         ((direction == LEFT && bump_left) || 
                          (direction == RIGHT && bump_right) ||
                          (bump_left && bump_right));
    
    // Next state logic
    always @(*) begin
        case (state)
            WALKING: begin
                if (fall_condition) next_state = FALLING;
                else if (dig_condition) next_state = DIGGING;
                else next_state = WALKING;
            end
            DIGGING: begin
                if (fall_condition) next_state = FALLING;
                else next_state = DIGGING;
            end
            FALLING: begin
                if (ground) begin
                    next_state = (fall_timer > 20) ? SPLATTER : WALKING;
                end else begin
                    next_state = FALLING;
                end
            end
            SPLATTER: next_state = SPLATTER;
            default: next_state = WALKING;
        endcase
    end
    
    // Direction update logic
    always @(*) begin
        if (state == WALKING && bump_condition && !fall_condition && !dig_condition) begin
            direction = ~direction; // Toggle direction on bump
        end
    end
    
    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALKING;
            direction <= LEFT;
            saved_direction <= LEFT;
            fall_timer <= 0;
        end else begin
            state <= next_state;
            
            // Update fall timer
            if (state == FALLING) begin
                fall_timer <= fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
            
            // Save direction when leaving walking state
            if (state == WALKING && next_state != WALKING) begin
                saved_direction <= direction;
            end
            
            // Restore direction when returning to walking
            if (next_state == WALKING && state != WALKING) begin
                direction <= saved_direction;
            end
        end
    end
    
    // Output logic
    assign walk_left = (state == WALKING) && (direction == LEFT);
    assign walk_right = (state == WALKING) && (direction == RIGHT);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);
    
endmodule