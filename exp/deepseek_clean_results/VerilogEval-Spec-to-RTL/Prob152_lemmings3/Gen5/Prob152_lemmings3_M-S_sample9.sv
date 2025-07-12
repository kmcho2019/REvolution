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
    parameter LEFT = 2'b00;
    parameter RIGHT = 2'b01;
    parameter FALL = 2'b10;
    parameter DIG_LEFT = 2'b11;
    parameter DIG_RIGHT = 3'b100;  // Unused, kept for clarity
    
    reg [1:0] state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end else begin
            case (state)
                LEFT: begin
                    if (~ground) 
                        state <= FALL;
                    else if (dig) 
                        state <= DIG_LEFT;
                    else if (bump_left) 
                        state <= RIGHT;
                end
                RIGHT: begin
                    if (~ground) 
                        state <= FALL;
                    else if (dig) 
                        // Would be DIG_RIGHT but we don't track direction during DIG
                        state <= DIG_LEFT;
                    else if (bump_right) 
                        state <= LEFT;
                end
                FALL: begin
                    if (ground) 
                        state <= (state == DIG_LEFT) ? LEFT : RIGHT;
                end
                DIG_LEFT: begin
                    if (~ground) 
                        state <= FALL;
                end
            endcase
        end
    end
    
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG_LEFT);
    
endmodule