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
    localparam FALL = 2'b10;
    
    reg [1:0] state;

    // Falling edge detector for ground
    reg ground_prev;
    wire ground_fall = ground_prev & ~ground;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            ground_prev <= 1'b1;
        end
        else begin
            ground_prev <= ground;
            
            // State transitions with priority:
            // 1. Falling has highest priority
            // 2. Then direction changes
            // 3. Otherwise maintain state
            case (state)
                LEFT: begin
                    if (ground_fall)
                        state <= FALL;
                    else if (bump_left)
                        state <= RIGHT;
                end
                
                RIGHT: begin
                    if (ground_fall)
                        state <= FALL;
                    else if (bump_right)
                        state <= LEFT;
                end
                
                FALL: begin
                    if (ground)
                        state <= state == FALL ? LEFT : state;  // Return to previous direction
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL);

endmodule