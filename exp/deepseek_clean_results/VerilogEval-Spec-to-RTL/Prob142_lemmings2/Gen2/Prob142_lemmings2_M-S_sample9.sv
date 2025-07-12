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

    // States
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALL = 2'b10;
    
    reg [1:0] state, next_state;
    reg direction; // 0=left, 1=right
    
    // State transitions
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground) next_state = FALL;
                else if (bump_left) next_state = WALK_RIGHT;
                else next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (!ground) next_state = FALL;
                else if (bump_right) next_state = WALK_LEFT;
                else next_state = WALK_RIGHT;
            end
            FALL: begin
                if (ground) next_state = direction ? WALK_RIGHT : WALK_LEFT;
                else next_state = FALL;
            end
            default: next_state = WALK_LEFT;
        endcase
    end
    
    // State and direction update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction <= 0;
        end else begin
            state <= next_state;
            // Update direction when transitioning between walking states
            if (state == WALK_LEFT && next_state == WALK_RIGHT)
                direction <= 1;
            else if (state == WALK_RIGHT && next_state == WALK_LEFT)
                direction <= 0;
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL);

endmodule