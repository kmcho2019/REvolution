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

    // One-hot state encoding
    parameter WALK_L = 2'b00;
    parameter WALK_R = 2'b01;
    parameter FALL   = 2'b10;
    parameter DIG    = 2'b11;
    
    reg [1:0] state, next_state;
    reg direction;  // 0 for left, 1 for right (used in FALL and DIG states)

    // State transition logic
    always @(*) begin
        case (state)
            WALK_L: begin
                if (!ground) begin
                    next_state = FALL;
                    direction = 0;
                end
                else if (dig) begin
                    next_state = DIG;
                    direction = 0;
                end
                else if (bump_left) begin
                    next_state = WALK_R;
                end
                else begin
                    next_state = WALK_L;
                end
            end
            WALK_R: begin
                if (!ground) begin
                    next_state = FALL;
                    direction = 1;
                end
                else if (dig) begin
                    next_state = DIG;
                    direction = 1;
                end
                else if (bump_right) begin
                    next_state = WALK_L;
                end
                else begin
                    next_state = WALK_R;
                end
            end
            FALL: begin
                if (ground) begin
                    next_state = direction ? WALK_R : WALK_L;
                end
                else begin
                    next_state = FALL;
                end
            end
            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                end
                else begin
                    next_state = DIG;
                end
            end
            default: next_state = WALK_L;
        endcase
    end

    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            direction <= 0;
        end
        else begin
            state <= next_state;
            // direction is set during state transitions
        end
    end

    // Output logic
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule