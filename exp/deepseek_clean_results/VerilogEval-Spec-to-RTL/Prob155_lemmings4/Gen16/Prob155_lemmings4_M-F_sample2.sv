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

    // State encoding
    parameter WALK_LEFT  = 3'b000;
    parameter WALK_RIGHT = 3'b001;
    parameter FALL_LEFT  = 3'b010;
    parameter FALL_RIGHT = 3'b011;
    parameter DIG_LEFT   = 3'b100;
    parameter DIG_RIGHT  = 3'b101;
    parameter SPLAT      = 3'b110;
    
    reg [2:0] state, next_state;
    reg [4:0] fall_timer;
    reg ground_prev;
    reg direction; // 0=left, 1=right

    // Edge detection for ground signal
    wire ground_falling = ground_prev & ~ground;
    wire ground_rising = ~ground_prev & ground;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_timer <= 0;
            ground_prev <= 1'b1;
            direction <= 1'b0; // start left
        end else begin
            ground_prev <= ground;
            state <= next_state;
            
            // Update fall timer
            if ((state == FALL_LEFT || state == FALL_RIGHT) && !ground) begin
                fall_timer <= fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WALK_LEFT, WALK_RIGHT: begin
                if (ground_falling) begin
                    next_state = direction ? FALL_RIGHT : FALL_LEFT;
                end else if (dig && ground) begin
                    next_state = direction ? DIG_RIGHT : DIG_LEFT;
                end else if (bump_left || bump_right) begin
                    if (bump_left && bump_right) begin
                        next_state = direction ? WALK_LEFT : WALK_RIGHT;
                    end else if (bump_left) begin
                        next_state = WALK_RIGHT;
                    end else if (bump_right) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = state;
                    end
                end else begin
                    next_state = state;
                end
            end
            
            FALL_LEFT, FALL_RIGHT: begin
                if (ground_rising) begin
                    if (fall_timer > 20) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = direction ? WALK_RIGHT : WALK_LEFT;
                    end
                end else begin
                    next_state = state;
                end
            end
            
            DIG_LEFT, DIG_RIGHT: begin
                if (!ground) begin
                    next_state = direction ? FALL_RIGHT : FALL_LEFT;
                end else begin
                    next_state = state;
                end
            end
            
            SPLAT: begin
                next_state = SPLAT;
            end
            
            default: next_state = WALK_LEFT;
        endcase
        
        // Update direction register
        case (next_state)
            WALK_LEFT:  direction = 1'b0;
            WALK_RIGHT: direction = 1'b1;
            FALL_LEFT: direction = 1'b0;
            FALL_RIGHT: direction = 1'b1;
            DIG_LEFT:   direction = 1'b0;
            DIG_RIGHT:  direction = 1'b1;
            default:    direction = direction;
        endcase
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);
    
endmodule