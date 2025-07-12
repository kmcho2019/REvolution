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
    // State encoding
    localparam LEFT = 2'b00;
    localparam RIGHT = 2'b01;
    localparam FALLING_LEFT = 2'b10;
    localparam FALLING_RIGHT = 2'b11;
    
    reg [1:0] state;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end
        else begin
            case (state)
                LEFT: begin
                    if (!ground)
                        state <= FALLING_LEFT;
                    else if (bump_left)
                        state <= RIGHT;
                end
                RIGHT: begin
                    if (!ground)
                        state <= FALLING_RIGHT;
                    else if (bump_right)
                        state <= LEFT;
                end
                FALLING_LEFT: begin
                    if (ground)
                        state <= LEFT;
                end
                FALLING_RIGHT: begin
                    if (ground)
                        state <= RIGHT;
                end
            endcase
        end
    end
    
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state[1]); // All falling states have MSB set
endmodule