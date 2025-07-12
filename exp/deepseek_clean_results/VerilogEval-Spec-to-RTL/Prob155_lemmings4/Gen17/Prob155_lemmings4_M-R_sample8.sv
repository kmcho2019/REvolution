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

    // Binary state encoding
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    parameter SPLAT = 2'b11;
    
    reg [1:0] state, next_state;
    reg direction;  // 1 = left, 0 = right
    reg [4:0] fall_timer;

    // Combinational next state logic
    always @(*) begin
        case (state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else begin
                    next_state = WALK;
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
            
            // Update direction only when walking and not transitioning to other states
            if (state == WALK && next_state == WALK) begin
                if (bump_left) direction <= 1'b0;
                if (bump_right) direction <= 1'b1;
                if (bump_left && bump_right) direction <= ~direction;
            end
            
            // Fall timer logic
            if (state == FALL && !ground) begin
                fall_timer <= fall_timer + 1;
            end else if (next_state != FALL) begin
                fall_timer <= 0;
            end
        end
    end

    // Output assignments
    assign walk_left = (state == WALK) & direction;
    assign walk_right = (state == WALK) & ~direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule