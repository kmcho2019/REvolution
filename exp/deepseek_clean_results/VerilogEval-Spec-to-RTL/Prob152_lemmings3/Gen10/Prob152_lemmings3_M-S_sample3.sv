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

    // States with direction encoded
    parameter LEFT  = 2'b00;
    parameter RIGHT = 2'b01;
    parameter FALL  = 2'b10;
    parameter DIG_L = 2'b11; // Digging while facing left
    parameter DIG_R = 2'b11; // Digging while facing right (same encoding)

    reg [1:0] state;
    reg is_digging;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            is_digging <= 0;
        end
        else case (state)
            LEFT: begin
                if (!ground)      state <= FALL;
                else if (dig)    begin state <= LEFT; is_digging <= 1; end
                else if (bump_left) state <= RIGHT;
                else is_digging <= 0;
            end
            
            RIGHT: begin
                if (!ground)      state <= FALL;
                else if (dig)     begin state <= RIGHT; is_digging <= 1; end
                else if (bump_right) state <= LEFT;
                else is_digging <= 0;
            end
            
            FALL: if (ground) state <= (is_digging ? (bump_left ? RIGHT : LEFT) : (state[0] ? RIGHT : LEFT));
            
            default: state <= LEFT; // Should never happen
        endcase
    end

    // Outputs
    assign walk_left = (state == LEFT) & ~is_digging;
    assign walk_right = (state == RIGHT) & ~is_digging;
    assign aaah = (state == FALL);
    assign digging = is_digging & (ground) & (state != FALL);

endmodule