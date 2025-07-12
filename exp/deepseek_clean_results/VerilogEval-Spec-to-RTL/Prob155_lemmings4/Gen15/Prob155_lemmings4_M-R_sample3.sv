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

    parameter WALK = 2'b00;
    parameter DIG  = 2'b01;
    parameter FALL = 2'b10;
    parameter SPLAT= 2'b11;

    reg [1:0] state, next_state;
    reg direction;  // 1=left, 0=right
    reg [4:0] fall_count;

    // State transition logic
    always @(*) begin
        case (state)
            WALK: begin
                if (!ground) 
                    next_state = FALL;
                else if (dig) 
                    next_state = DIG;
                else 
                    next_state = WALK;
            end
            
            DIG: 
                next_state = (!ground) ? FALL : DIG;
            
            FALL: 
                next_state = (ground) ? ((fall_count > 20) ? SPLAT : WALK) : FALL;
            
            SPLAT: 
                next_state = SPLAT;
            
            default: 
                next_state = WALK;
        endcase
    end

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b1;
            fall_count <= 5'b0;
        end else begin
            state <= next_state;
            
            // Update direction only in WALK state when not falling/digging
            if (state == WALK && ground && !dig) begin
                if (bump_left || bump_right)
                    direction <= bump_left;
            end
            
            // Fall counter logic
            if (state == FALL) begin
                if (next_state == FALL)
                    fall_count <= fall_count + 1;
                else
                    fall_count <= 5'b0;
            end else begin
                fall_count <= 5'b0;
            end
        end
    end

    // Output logic
    assign walk_left = (state == WALK) & direction & (state != SPLAT);
    assign walk_right = (state == WALK) & ~direction & (state != SPLAT);
    assign aaah = (state == FALL) & (state != SPLAT);
    assign digging = (state == DIG) & (state != SPLAT);

endmodule