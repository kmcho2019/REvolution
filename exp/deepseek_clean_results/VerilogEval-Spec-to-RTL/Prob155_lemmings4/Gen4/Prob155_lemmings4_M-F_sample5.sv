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
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_counter;
    
    // State transition logic
    always @(*) begin
        next_state = state;
        
        case (state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                end
                else if (dig) begin
                    next_state = DIG;
                end
                // Direction changes handled in sequential logic
            end
            
            FALL: begin
                if (ground) begin
                    next_state = (fall_counter > 20) ? SPLAT : WALK;
                end
            end
            
            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                end
                else if (!dig) begin
                    next_state = WALK;
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
            direction <= 1'b1;  // Start walking left
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update direction only when walking and not falling/digging
            if (state == WALK && next_state == WALK) begin
                if (bump_left && direction) begin
                    direction <= 0;
                end
                else if (bump_right && !direction) begin
                    direction <= 1;
                end
            end
            
            // Update fall counter
            if (state == FALL) begin
                if (!ground) begin
                    fall_counter <= fall_counter + 1;
                end else begin
                    fall_counter <= 0;
                end
            end else begin
                fall_counter <= 0;
            end
        end
    end
    
    // Output logic
    assign walk_left  = (state == WALK) && direction;
    assign walk_right = (state == WALK) && !direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);
    
endmodule