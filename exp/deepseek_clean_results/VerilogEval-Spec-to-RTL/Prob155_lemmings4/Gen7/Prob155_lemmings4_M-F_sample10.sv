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
    parameter WALK_L = 3'd0;
    parameter WALK_R = 3'd1;
    parameter DIG_L  = 3'd2;
    parameter DIG_R  = 3'd3;
    parameter FALL   = 3'd4;
    parameter SPLAT  = 3'd5;

    reg [2:0] state, next_state;
    reg [4:0] fall_counter;

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update fall counter
            if (state == FALL) begin
                if (~ground) begin
                    fall_counter <= fall_counter + 1;
                end
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WALK_L: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG_L;
                end else if (bump_left) begin
                    next_state = WALK_R;
                end else begin
                    next_state = WALK_L;
                end
            end
            
            WALK_R: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG_R;
                end else if (bump_right) begin
                    next_state = WALK_L;
                end else begin
                    next_state = WALK_R;
                end
            end
            
            DIG_L: begin
                if (~ground) begin
                    next_state = FALL;
                end else begin
                    next_state = DIG_L;
                end
            end
            
            DIG_R: begin
                if (~ground) begin
                    next_state = FALL;
                end else begin
                    next_state = DIG_R;
                end
            end
            
            FALL: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLAT;
                    end else begin
                        // Return to previous direction
                        case (state)
                            DIG_L, WALK_L: next_state = WALK_L;
                            DIG_R, WALK_R: next_state = WALK_R;
                            default: next_state = WALK_L;
                        endcase
                    end
                end else begin
                    next_state = FALL;
                end
            end
            
            SPLAT: begin
                next_state = SPLAT;
            end
            
            default: begin
                next_state = WALK_L;
            end
        endcase
    end

    // Output logic
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALL);
    assign digging = (state == DIG_L || state == DIG_R);

endmodule