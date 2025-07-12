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

    // Combined state encoding
    localparam [3:0]
        WALK_LEFT   = 4'b0000,
        WALK_RIGHT  = 4'b0001,
        FALL_LEFT   = 4'b0010,
        FALL_RIGHT  = 4'b0011,
        DIG_LEFT    = 4'b0100,
        DIG_RIGHT   = 4'b0101,
        SPLAT       = 4'b0110;
    
    reg [3:0] state, next_state;
    reg [4:0] fall_timer;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_timer <= 0;
        end else begin
            state <= next_state;
            
            // Update fall timer
            if (state == FALL_LEFT || state == FALL_RIGHT) begin
                fall_timer <= ground ? 0 : fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Next state logic with explicit priorities
    always @(*) begin
        case (state)
            WALK_LEFT, WALK_RIGHT: begin
                if (~ground) begin
                    next_state = state[0] ? FALL_RIGHT : FALL_LEFT;
                end else if (dig && ground) begin
                    next_state = state[0] ? DIG_RIGHT : DIG_LEFT;
                end else if (bump_left || bump_right) begin
                    if ((bump_left && !bump_right) || (bump_left && bump_right)) begin
                        next_state = state[0] ? WALK_LEFT : WALK_RIGHT;
                    end else if (bump_right && !bump_left) begin
                        next_state = state[0] ? WALK_LEFT : WALK_RIGHT;
                    end else begin
                        next_state = state;
                    end
                end else begin
                    next_state = state;
                end
            end
            
            FALL_LEFT, FALL_RIGHT: begin
                if (ground) begin
                    next_state = (fall_timer >= 20) ? SPLAT : 
                                (state[0] ? WALK_RIGHT : WALK_LEFT);
                end else begin
                    next_state = state;
                end
            end
            
            DIG_LEFT, DIG_RIGHT: begin
                if (~ground) begin
                    next_state = state[0] ? FALL_RIGHT : FALL_LEFT;
                end else begin
                    next_state = state;
                end
            end
            
            SPLAT: begin
                next_state = SPLAT;
            end
            
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule