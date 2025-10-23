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
    // Combined state and direction encoding
    parameter WL   = 2'b00;  // Walk Left
    parameter WR   = 2'b01;  // Walk Right
    parameter FALL = 2'b10;  // Falling
    parameter DIG  = 2'b11;  // Digging
    
    reg [1:0] state, next_state;
    
    // State transition logic
    always @(*) begin
        case (state)
            WL: begin
                if (~ground)      next_state = FALL;
                else if (dig)     next_state = DIG;
                else if (bump_left) next_state = WR;
                else              next_state = WL;
            end
            WR: begin
                if (~ground)      next_state = FALL;
                else if (dig)     next_state = DIG;
                else if (bump_right) next_state = WL;
                else              next_state = WR;
            end
            FALL: begin
                if (ground) begin
                    if (state == FALL)  // Return to previous direction
                        next_state = (state == WL) ? WL : WR;
                    else
                        next_state = (state == WL) ? WL : WR;
                end else
                    next_state = FALL;
            end
            DIG: begin
                if (~ground) next_state = FALL;
                else         next_state = DIG;
            end
        endcase
    end
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;  // Start walking left
        end else begin
            state <= next_state;
        end
    end
    
    // Output logic
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);
    
endmodule