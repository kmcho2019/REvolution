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

    // State encoding with direction bit (bit 0)
    parameter [2:0] 
        WALK  = 3'b000,
        FALL  = 3'b001,
        DIG   = 3'b010,
        SPLAT = 3'b011;
    reg [2:0] state, next_state;
    reg direction; // 0=left, 1=right

    // Fall timeout tracking
    reg [4:0] fall_timer;
    wire timeout = (fall_timer > 20);

    // State transition logic with explicit priorities
    always @(*) begin
        next_state = state;
        case (state)
            WALK: begin
                if (~ground) begin
                    next_state = FALL; // Highest priority: fall
                end else if (dig) begin
                    next_state = DIG;   // Next priority: dig
                end else if (bump_left || bump_right) begin
                    // Switch direction if bumped (even both sides)
                    direction = bump_left ? 1'b1 : (bump_right ? 1'b0 : direction);
                end
            end
            FALL: begin
                if (ground) begin
                    next_state = timeout ? SPLAT : WALK;
                end
            end
            DIG: begin
                if (~ground) begin
                    next_state = FALL;
                end
            end
            SPLAT: begin
                next_state = SPLAT; // Stay in splat forever
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0; // Start walking left
            fall_timer <= 0;
        end else begin
            state <= next_state;
            
            // Update fall timer
            if (state == FALL) begin
                if (~ground) begin
                    fall_timer <= fall_timer + 1;
                end else begin
                    fall_timer <= 0;
                end
            end else begin
                fall_timer <= 0; // Reset timer when not falling
            end
        end
    end

    // Output logic
    assign walk_left = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule