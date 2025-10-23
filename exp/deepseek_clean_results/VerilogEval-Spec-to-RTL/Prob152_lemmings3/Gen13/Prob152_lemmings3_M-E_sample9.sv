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
    localparam WALK_LEFT  = 3'b000;
    localparam WALK_RIGHT = 3'b001;
    localparam FALL_LEFT  = 3'b010;
    localparam FALL_RIGHT = 3'b011;
    localparam DIG_LEFT   = 3'b100;
    localparam DIG_RIGHT  = 3'b101;

    reg [2:0] state;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            case (state)
                WALK_LEFT, WALK_RIGHT: begin
                    if (~ground) begin
                        state <= (state == WALK_LEFT) ? FALL_LEFT : FALL_RIGHT;
                    end else if (dig) begin
                        state <= (state == WALK_LEFT) ? DIG_LEFT : DIG_RIGHT;
                    end else begin
                        // Handle bumps
                        if (state == WALK_LEFT && bump_left)
                            state <= WALK_RIGHT;
                        else if (state == WALK_RIGHT && bump_right)
                            state <= WALK_LEFT;
                        // Handle simultaneous bumps
                        if (bump_left && bump_right)
                            state <= (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
                    end
                end
                
                FALL_LEFT, FALL_RIGHT: begin
                    if (ground)
                        state <= (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;
                end
                
                DIG_LEFT, DIG_RIGHT: begin
                    if (~ground)
                        state <= (state == DIG_LEFT) ? FALL_LEFT : FALL_RIGHT;
                end
            endcase
        end
    end

    // Output logic
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule