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
    parameter WALKING = 2'b00;
    parameter FALLING = 2'b01;
    parameter DIGGING  = 2'b10;
    parameter SPLAT    = 2'b11;
    
    reg [1:0] state, next_state;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_counter;
    
    // Next state logic with strict priority
    always @(*) begin
        case (state)
            WALKING: begin
                if (~ground)
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else
                    next_state = WALKING;
            end
            FALLING: begin
                if (ground)
                    next_state = (fall_counter > 20) ? SPLAT : WALKING;
                else
                    next_state = FALLING;
            end
            DIGGING: begin
                if (~ground)
                    next_state = FALLING;
                else
                    next_state = DIGGING;
            end
            SPLAT: next_state = SPLAT;
            default: next_state = WALKING;
        endcase
    end
    
    // State and registers update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALKING;
            direction <= 0;  // start walking left
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update direction only when walking on ground and not digging
            if (state == WALKING && ground && next_state == WALKING) begin
                case ({bump_left, bump_right})
                    2'b01: direction <= 0;  // bump_right: walk left
                    2'b10: direction <= 1;   // bump_left: walk right
                    2'b11: direction <= ~direction;  // both bumps: toggle
                    default: direction <= direction;  // no change
                endcase
            end
            
            // Update fall counter
            if (state == FALLING) begin
                fall_counter <= (~ground) ? fall_counter + 1 : 0;
            end else begin
                fall_counter <= 0;
            end
        end
    end
    
    // Output logic - pure combinational
    assign walk_left = (state == WALKING) & ~direction & (state != SPLAT);
    assign walk_right = (state == WALKING) & direction & (state != SPLAT);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);
    
endmodule