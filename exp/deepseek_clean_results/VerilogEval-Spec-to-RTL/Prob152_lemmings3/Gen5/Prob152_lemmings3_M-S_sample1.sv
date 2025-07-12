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
    parameter LEFT  = 2'b00;
    parameter RIGHT = 2'b01;
    parameter FALL  = 2'b10;
    
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            LEFT: begin
                if (~ground) next_state = FALL;
                else if (dig) next_state = LEFT; // Keep LEFT but digging=1
                else if (bump_left) next_state = RIGHT;
                else next_state = LEFT;
            end
            RIGHT: begin
                if (~ground) next_state = FALL;
                else if (dig) next_state = RIGHT; // Keep RIGHT but digging=1
                else if (bump_right) next_state = LEFT;
                else next_state = RIGHT;
            end
            FALL: begin
                if (ground) next_state = (state == LEFT) ? LEFT : RIGHT;
                else next_state = FALL;
            end
            default: next_state = LEFT;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) state <= LEFT;
        else state <= next_state;
    end

    assign walk_left  = (state == LEFT) && ground && ~dig;
    assign walk_right = (state == RIGHT) && ground && ~dig;
    assign aaah       = (state == FALL);
    assign digging    = ((state == LEFT) || (state == RIGHT)) && ground && dig;
endmodule