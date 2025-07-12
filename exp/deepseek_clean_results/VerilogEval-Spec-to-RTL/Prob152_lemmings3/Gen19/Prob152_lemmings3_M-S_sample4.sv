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

    // States
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALL = 2'b10;
    
    reg [1:0] state;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (~ground) begin
                        state <= FALL;
                    end else if (dig) begin
                        // Stay in WALK_LEFT but output digging
                    end else if (bump_left) begin
                        state <= WALK_RIGHT;
                    end
                end
                
                WALK_RIGHT: begin
                    if (~ground) begin
                        state <= FALL;
                    end else if (dig) begin
                        // Stay in WALK_RIGHT but output digging
                    end else if (bump_right) begin
                        state <= WALK_LEFT;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        // Return to previous walking state
                        state <= (state == FALL) ? WALK_LEFT : state;
                    end
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT) && ground && ~dig;
    assign walk_right = (state == WALK_RIGHT) && ground && ~dig;
    assign aaah = (state == FALL);
    assign digging = ((state == WALK_LEFT) || (state == WALK_RIGHT)) && ground && dig;

endmodule