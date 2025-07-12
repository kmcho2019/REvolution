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

    // Unified state encoding
    localparam [2:0] 
        WALK_L = 3'b000,
        WALK_R = 3'b001,
        FALL_L = 3'b010,
        FALL_R = 3'b011,
        DIG_L  = 3'b100,
        DIG_R  = 3'b101,
        SPLAT  = 3'b110;

    reg [2:0] state, next_state;
    reg [4:0] fall_counter;
    reg saved_dir; // 0=left, 1=right

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_counter <= 0;
            saved_dir <= 0;
        end else begin
            state <= next_state;
            
            // Update fall counter
            if (state == FALL_L || state == FALL_R) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
            
            // Save direction when transitioning to fall/dig
            if ((state == WALK_L || state == WALK_R) && 
                (next_state == FALL_L || next_state == FALL_R || 
                 next_state == DIG_L || next_state == DIG_R)) begin
                saved_dir <= state[0]; // Save L/R bit
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WALK_L, WALK_R: begin
                if (~ground) begin
                    next_state = state[0] ? FALL_R : FALL_L;
                end else if (dig) begin
                    next_state = state[0] ? DIG_R : DIG_L;
                end else if ((state == WALK_L && bump_left) || 
                           (state == WALK_R && bump_right)) begin
                    next_state = state[0] ? WALK_L : WALK_R;
                end else begin
                    next_state = state;
                end
            end
            
            FALL_L, FALL_R: begin
                if (ground) begin
                    next_state = (fall_counter > 20) ? SPLAT : 
                                 (saved_dir ? WALK_R : WALK_L);
                end else begin
                    next_state = state;
                end
            end
            
            DIG_L, DIG_R: begin
                if (~ground) begin
                    next_state = state[0] ? FALL_R : FALL_L;
                end else begin
                    next_state = state;
                end
            end
            
            SPLAT: next_state = SPLAT;
            
            default: next_state = WALK_L;
        endcase
    end

    // Output logic
    assign walk_left = (state == WALK_L) || 
                      ((state == WALK_R || state == DIG_R || state == FALL_R) && 
                       saved_dir == 0 && state != SPLAT);
    assign walk_right = (state == WALK_R) || 
                       ((state == WALK_L || state == DIG_L || state == FALL_L) && 
                        saved_dir == 1 && state != SPLAT);
    assign aaah = (state == FALL_L || state == FALL_R);
    assign digging = (state == DIG_L || state == DIG_R);

endmodule