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

    // States: LEFT, RIGHT, FALLING
    reg [1:0] state;
    localparam LEFT = 2'b00;
    localparam RIGHT = 2'b01;
    localparam FALLING = 2'b10;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end
        else begin
            case (state)
                LEFT: begin
                    if (!ground) begin
                        state <= FALLING;
                    end
                    else if (bump_left) begin
                        state <= RIGHT;
                    end
                end
                RIGHT: begin
                    if (!ground) begin
                        state <= FALLING;
                    end
                    else if (bump_right) begin
                        state <= LEFT;
                    end
                end
                FALLING: begin
                    if (ground) begin
                        // Return to previous direction (LEFT if we came from LEFT, RIGHT otherwise)
                        state <= (state == FALLING) ? LEFT : state;
                    end
                end
            endcase
        end
    end
    
    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALLING);

endmodule