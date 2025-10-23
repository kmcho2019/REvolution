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
    localparam [1:0] 
        LEFT    = 2'b00,
        RIGHT   = 2'b01,
        FALLING = 2'b10,
        SPLAT   = 2'b11;

    reg [1:0] state, next_state;
    reg is_digging;
    reg [4:0] fall_counter;

    // State transitions with strict priorities
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            is_digging <= 0;
            fall_counter <= 0;
        end else begin
            // Update fall counter
            if (state == FALLING) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end

            // State transition with priorities
            case (state)
                LEFT, RIGHT: begin
                    if (~ground) begin
                        state <= FALLING;
                        is_digging <= 0;
                    end else if (dig && ~is_digging) begin
                        is_digging <= 1;
                    end else if (is_digging) begin
                        // Stay digging until ground disappears
                        is_digging <= ground;
                    end else begin
                        // Handle direction changes
                        if ((state == LEFT && bump_left) || 
                            (state == RIGHT && bump_right)) begin
                            state <= (state == LEFT) ? RIGHT : LEFT;
                        end
                    end
                end
                
                FALLING: begin
                    if (ground) begin
                        if (fall_counter > 20) begin
                            state <= SPLAT;
                        end else begin
                            state <= is_digging ? (state == LEFT ? LEFT : RIGHT) : state;
                            is_digging <= 0;
                        end
                    end
                end
                
                SPLAT: begin
                    // Stay in splat state forever
                    state <= SPLAT;
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == LEFT) && (state != SPLAT) && ~is_digging;
    assign walk_right = (state == RIGHT) && (state != SPLAT) && ~is_digging;
    assign aaah = (state == FALLING);
    assign digging = ((state == LEFT || state == RIGHT) && is_digging);

endmodule