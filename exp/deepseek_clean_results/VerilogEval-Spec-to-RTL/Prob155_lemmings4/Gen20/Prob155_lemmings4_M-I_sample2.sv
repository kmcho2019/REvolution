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

    // State encoding (3 bits for all states)
    parameter [2:0] WALK_L   = 3'b000;
    parameter [2:0] WALK_R   = 3'b001;
    parameter [2:0] DIGGING  = 3'b010;
    parameter [2:0] FALLING  = 3'b011;
    parameter [2:0] SPLATTER = 3'b100;
    
    reg [2:0] state, next_state;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_counter;
    
    // Output logic - all outputs 0 in SPLATTER state
    assign walk_left = (state == WALK_L) && (state != SPLATTER);
    assign walk_right = (state == WALK_R) && (state != SPLATTER);
    assign aaah = (state == FALLING) && (state != SPLATTER);
    assign digging = (state == DIGGING) && (state != SPLATTER);
    
    // Fall counter logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            fall_counter <= 0;
        end else begin
            if (state == FALLING) begin
                fall_counter <= ground ? 0 : fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            SPLATTER: next_state = SPLATTER;
            
            FALLING: begin
                if (ground) begin
                    next_state = (fall_counter >= 20) ? SPLATTER : 
                                (direction ? WALK_R : WALK_L);
                end else begin
                    next_state = FALLING;
                end
            end
            
            DIGGING: begin
                next_state = ground ? DIGGING : FALLING;
            end
            
            WALK_L: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left) begin
                    next_state = WALK_R;
                end else begin
                    next_state = WALK_L;
                end
            end
            
            WALK_R: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_right) begin
                    next_state = WALK_L;
                end else begin
                    next_state = WALK_R;
                end
            end
            
            default: next_state = WALK_L;
        endcase
    end
    
    // State and direction update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            direction <= 0;
        end else begin
            state <= next_state;
            
            // Update direction only when walking and bumped
            if (state == WALK_L && bump_left) begin
                direction <= 1;
            end else if (state == WALK_R && bump_right) begin
                direction <= 0;
            end
        end
    end

endmodule