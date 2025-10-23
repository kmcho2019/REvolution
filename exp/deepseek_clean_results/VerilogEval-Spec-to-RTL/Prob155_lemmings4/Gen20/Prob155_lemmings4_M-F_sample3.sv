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
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    parameter SPLAT = 2'b11;
    
    reg [1:0] state, next_state;
    reg direction, next_direction;  // 0=left, 1=right
    reg [4:0] fall_timer;
    
    // State transition logic
    always @(*) begin
        next_state = state;
        next_direction = direction;
        
        case (state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else begin
                    // Only change direction if not falling or digging
                    if (bump_left || bump_right) begin
                        if (bump_left && bump_right)
                            next_direction = !direction;
                        else if (bump_left)
                            next_direction = 1'b1;
                        else if (bump_right)
                            next_direction = 1'b0;
                    end
                end
            end
            
            FALL: begin
                if (ground) begin
                    next_state = (fall_timer > 20) ? SPLAT : WALK;
                end
            end
            
            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                end
            end
            
            SPLAT: begin
                next_state = SPLAT;
            end
        endcase
    end
    
    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0;
            fall_timer <= 0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            
            // Fall timer logic
            if (state == FALL) begin
                if (!ground) begin
                    fall_timer <= fall_timer + 1;
                end else begin
                    fall_timer <= 0;
                end
            end else begin
                fall_timer <= 0;
            end
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK) && !direction && (state != SPLAT);
    assign walk_right = (state == WALK) && direction && (state != SPLAT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);
    
    // Ensure all outputs are zero in SPLAT state
    assign {walk_left, walk_right, aaah, digging} = (state == SPLAT) ? 4'b0000 : 
                                                   {walk_left, walk_right, aaah, digging};
    
endmodule