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

    // State encoding with direction included
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

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update fall counter
            if (state == FALL_LEFT || state == FALL_RIGHT) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Next state logic with clear priority
    always @(*) begin
        case (state)
            WALK_LEFT, WALK_RIGHT: begin
                if (~ground) begin
                    next_state = (state == WALK_LEFT) ? FALL_LEFT : FALL_RIGHT;
                end else if (dig) begin
                    next_state = (state == WALK_LEFT) ? DIG_LEFT : DIG_RIGHT;
                end else if ((state == WALK_LEFT && bump_left) || 
                            (state == WALK_RIGHT && bump_right)) begin
                    next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
                end else begin
                    next_state = state;
                end
            end
            
            FALL_LEFT, FALL_RIGHT: begin
                if (ground) begin
                    next_state = (fall_counter > 20) ? SPLAT : 
                                ((state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT);
                end else begin
                    next_state = state;
                end
            end
            
            DIG_LEFT, DIG_RIGHT: begin
                if (~ground) begin
                    next_state = (state == DIG_LEFT) ? FALL_LEFT : FALL_RIGHT;
                end else begin
                    next_state = state;
                end
            end
            
            SPLAT: next_state = SPLAT;
            
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic - pure combinatorial
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule