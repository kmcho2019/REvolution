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
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    parameter SPLAT = 2'b11;
    
    reg [1:0] state, next_state;
    reg direction;  // 1 = left, 0 = right
    reg [4:0] fall_timer;

    // Combinational next state logic with proper priority
    always @(*) begin
        case (state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;  // Highest priority
                end else if (dig) begin
                    next_state = DIG;   // Medium priority
                end else begin
                    next_state = WALK;  // Default stay in WALK
                end
            end
            
            FALL: begin
                if (ground) begin
                    next_state = (fall_timer > 20) ? SPLAT : WALK;
                end else begin
                    next_state = FALL;
                end
            end
            
            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                end else begin
                    next_state = DIG;
                end
            end
            
            SPLAT: begin
                next_state = SPLAT;
            end
            
            default: next_state = WALK;
        endcase
    end

    // Sequential state update and direction logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b1;  // Start walking left
            fall_timer <= 0;
        end else begin
            state <= next_state;
            
            // Update direction only in WALK state (with priority over direction changes)
            if (state == WALK && next_state == WALK) begin
                case ({bump_left, bump_right})
                    2'b01: direction <= 1'b1;    // bump_right: walk left
                    2'b10: direction <= 1'b0;    // bump_left: walk right
                    2'b11: direction <= ~direction; // both: toggle direction
                    default: direction <= direction; // no change
                endcase
            end
            
            // Fall timer logic - only increment while falling and reset when leaving FALL
            if (state == FALL) begin
                if (!ground) begin
                    fall_timer <= fall_timer + 1;
                end
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Output assignments (Moore machine - outputs depend only on state)
    assign walk_left = (state == WALK) & direction & (state != SPLAT);
    assign walk_right = (state == WALK) & ~direction & (state != SPLAT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule