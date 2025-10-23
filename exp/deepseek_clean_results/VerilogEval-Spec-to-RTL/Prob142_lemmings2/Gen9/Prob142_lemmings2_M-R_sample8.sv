module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);
    // One-hot state encoding
    parameter WALK_LEFT  = 2'b01;
    parameter WALK_RIGHT = 2'b10;
    parameter FALLING    = 2'b00;
    
    reg [1:0] state;
    reg direction;  // 0 for left, 1 for right
    
    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction <= 0;
        end
        else begin
            case (state)
                WALK_LEFT: begin
                    if (!ground) begin
                        state <= FALLING;
                    end
                    else if (bump_left) begin
                        state <= WALK_RIGHT;
                        direction <= 1;
                    end
                end
                
                WALK_RIGHT: begin
                    if (!ground) begin
                        state <= FALLING;
                    end
                    else if (bump_right) begin
                        state <= WALK_LEFT;
                        direction <= 0;
                    end
                end
                
                FALLING: begin
                    if (ground) begin
                        state <= direction ? WALK_RIGHT : WALK_LEFT;
                    end
                end
            endcase
        end
    end
    
    // Output logic
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);
endmodule