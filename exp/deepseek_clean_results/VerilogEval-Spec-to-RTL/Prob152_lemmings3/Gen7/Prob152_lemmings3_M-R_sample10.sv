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
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALL = 2'b10;
    parameter DIG = 2'b11;
    
    reg [1:0] state, next_state;
    reg walking_left;  // Direction flag

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (~ground) next_state = FALL;
                else if (dig) next_state = DIG;
                else next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (~ground) next_state = FALL;
                else if (dig) next_state = DIG;
                else next_state = WALK_RIGHT;
            end
            FALL: begin
                if (ground) next_state = walking_left ? WALK_LEFT : WALK_RIGHT;
                else next_state = FALL;
            end
            DIG: begin
                if (~ground) next_state = FALL;
                else next_state = DIG;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Direction change logic (combinational)
    always @(*) begin
        if (areset) walking_left = 1;
        else if (state == WALK_LEFT || state == WALK_RIGHT) begin
            if (bump_left && bump_right) walking_left = ~walking_left;
            else if (bump_left) walking_left = 0;
            else if (bump_right) walking_left = 1;
            else walking_left = walking_left;
        end
    end

    // State register (sequential)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walking_left <= 1;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule