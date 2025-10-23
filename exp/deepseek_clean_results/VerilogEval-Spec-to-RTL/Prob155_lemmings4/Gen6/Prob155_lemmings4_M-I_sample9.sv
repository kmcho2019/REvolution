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

    // State encoding with direction and action
    localparam [2:0]
        WALK_LEFT   = 3'b000,
        WALK_RIGHT  = 3'b001,
        FALL_LEFT   = 3'b010,
        FALL_RIGHT  = 3'b011,
        DIG_LEFT    = 3'b100,
        DIG_RIGHT   = 3'b101,
        SPLAT       = 3'b110;

    reg [2:0] state, next_state;
    reg [4:0] fall_counter;

    // State transitions with synchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update fall counter only when in fall state
            if ((state == FALL_LEFT || state == FALL_RIGHT) && !ground) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Next state logic with strict priority
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL_LEFT;
                end else if (dig) begin
                    next_state = DIG_LEFT;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else if (dig) begin
                    next_state = DIG_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            
            FALL_LEFT: begin
                if (ground) begin
                    next_state = (fall_counter > 20) ? SPLAT : WALK_LEFT;
                end else begin
                    next_state = FALL_LEFT;
                end
            end
            
            FALL_RIGHT: begin
                if (ground) begin
                    next_state = (fall_counter > 20) ? SPLAT : WALK_RIGHT;
                end else begin
                    next_state = FALL_RIGHT;
                end
            end
            
            DIG_LEFT: begin
                if (!ground) begin
                    next_state = FALL_LEFT;
                end else begin
                    next_state = DIG_LEFT;
                end
            end
            
            DIG_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else begin
                    next_state = DIG_RIGHT;
                end
            end
            
            SPLAT: next_state = SPLAT;
            
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic - pure combinatorial
    assign walk_left = (state == WALK_LEFT || state == DIG_LEFT);
    assign walk_right = (state == WALK_RIGHT || state == DIG_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule