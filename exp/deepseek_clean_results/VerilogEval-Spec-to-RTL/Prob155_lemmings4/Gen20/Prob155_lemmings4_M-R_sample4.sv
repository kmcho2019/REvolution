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
    parameter WALK  = 2'b00;
    parameter DIG   = 2'b01;
    parameter FALL  = 2'b10;
    parameter SPLAT = 2'b11;
    
    reg [1:0] state, next_state;
    reg direction, next_direction;  // 0=left, 1=right
    reg [4:0] fall_counter;
    
    // State transition logic
    always @(*) begin
        next_state = state;
        next_direction = direction;
        
        if (state == SPLAT) begin
            next_state = SPLAT;
        end
        else if (!ground) begin  // Fall has highest priority
            next_state = FALL;
        end
        else if (state == FALL) begin
            if (ground) begin
                next_state = (fall_counter > 20) ? SPLAT : WALK;
            end
        end
        else if (dig && state == WALK) begin  // Dig has priority over bump
            next_state = DIG;
        end
        else if (state == DIG) begin
            if (ground) begin
                next_state = WALK;
            end
        end
        else begin  // WALK state
            if (bump_left || bump_right) begin
                next_direction = bump_left ? 1'b1 : 1'b0;
            end
        end
    end
    
    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            
            // Fall counter logic
            if (state == FALL && !ground) begin
                fall_counter <= fall_counter + 1;
            end
            else if (state != FALL) begin
                fall_counter <= 0;
            end
        end
    end
    
    // Output assignments
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule