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

    // States - 2 bits: [1] is FALL, [0] is direction (0=left, 1=right)
    parameter LEFT  = 2'b00;
    parameter RIGHT = 2'b01;
    parameter FALL  = 2'b10;
    
    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            LEFT: begin
                if (!ground)
                    next_state = FALL;
                else if (bump_left)
                    next_state = RIGHT;
                else
                    next_state = LEFT;
            end
            RIGHT: begin
                if (!ground)
                    next_state = FALL;
                else if (bump_right)
                    next_state = LEFT;
                else
                    next_state = RIGHT;
            end
            FALL: begin
                next_state = ground ? {1'b0, state[0]} : FALL; // Maintain direction
            end
            default: next_state = LEFT;
        endcase
    end

    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    // Output logic - Moore style
    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = state[1];  // FALL state has MSB set

endmodule