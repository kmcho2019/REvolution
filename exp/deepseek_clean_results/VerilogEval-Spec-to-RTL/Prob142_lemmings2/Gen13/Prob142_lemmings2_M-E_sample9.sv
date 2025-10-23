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

    // Combined state and direction encoding
    parameter LEFT = 2'b00;
    parameter RIGHT = 2'b01;
    parameter FALL = 2'b10;
    
    reg [1:0] state;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end
        else begin
            case (state)
                LEFT: begin
                    if (!ground) begin
                        state <= FALL;
                    end
                    else if (bump_left) begin
                        state <= RIGHT;
                    end
                end
                RIGHT: begin
                    if (!ground) begin
                        state <= FALL;
                    end
                    else if (bump_right) begin
                        state <= LEFT;
                    end
                end
                FALL: begin
                    if (ground) begin
                        // Return to previous direction
                        state <= (state == FALL) ? LEFT : state;
                    end
                end
            endcase
        end
    end
    
    // Output logic - direct mapping
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL);

endmodule