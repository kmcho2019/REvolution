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

    // States
    typedef enum {WALK, FALL, DIG, SPLAT} state_t;
    state_t state, next_state;
    
    // Direction (0=left, 1=right)
    reg direction;
    reg [4:0] fall_cycles;

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0; // Start walking left
            fall_cycles <= 0;
        end else begin
            state <= next_state;
            
            // Update direction when walking and bumped
            if (state == WALK) begin
                if (bump_left) direction <= 1;
                if (bump_right) direction <= 0;
            end
            
            // Update fall counter
            if (state == FALL) begin
                fall_cycles <= fall_cycles + 1;
            end else begin
                fall_cycles <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WALK: begin
                if (~ground)      next_state = FALL;
                else if (dig)     next_state = DIG;
                else              next_state = WALK;
            end
            
            FALL: begin
                if (ground) begin
                    if (fall_cycles > 20) next_state = SPLAT;
                    else                 next_state = WALK;
                end else begin
                    next_state = FALL;
                end
            end
            
            DIG: begin
                if (~ground)     next_state = FALL;
                else             next_state = DIG;
            end
            
            SPLAT: begin
                next_state = SPLAT;
            end
        endcase
    end

    // Output logic
    assign walk_left = (state == WALK) && ~direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule