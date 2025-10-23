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
    parameter WALK = 2'd0;
    parameter FALL = 2'd1;
    parameter DIG = 2'd2;
    parameter SPLAT = 2'd3;
    
    reg [1:0] state, next_state;
    reg dir;  // 0=left, 1=right
    reg [4:0] fall_counter;

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 0;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update fall counter
            if (state == FALL) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
            
            // Update direction when walking and bumped
            if (state == WALK && ~ground && next_state == FALL) begin
                // Keep direction when starting to fall
            end else if (state == WALK && next_state == WALK) begin
                if (bump_left) dir <= 1;
                if (bump_right) dir <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WALK: begin
                if (~ground) next_state = FALL;
                else if (dig) next_state = DIG;
                else next_state = WALK;
            end
            
            FALL: begin
                if (ground) begin
                    if (fall_counter > 20) next_state = SPLAT;
                    else next_state = WALK;
                end else begin
                    next_state = FALL;
                end
            end
            
            DIG: begin
                if (~ground) next_state = FALL;
                else next_state = DIG;
            end
            
            SPLAT: next_state = SPLAT;
            
            default: next_state = WALK;
        endcase
    end

    // Output logic
    assign walk_left = (state == WALK) & ~dir & (state != SPLAT);
    assign walk_right = (state == WALK) & dir & (state != SPLAT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule