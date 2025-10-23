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
                    if (!ground)
                        state <= FALLING;
                    else if (bump_left)
                        state <= RIGHT;
                end
                RIGHT: begin
                    if (!ground)
                        state <= FALLING;
                    else if (bump_right)
                        state <= LEFT;
                end
                FALLING: begin
                    if (ground)
                        state <= (state == FALLING) ? LEFT : state; // Return to previous direction
                end
            endcase
        end
    end
    
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALLING);

endmodule