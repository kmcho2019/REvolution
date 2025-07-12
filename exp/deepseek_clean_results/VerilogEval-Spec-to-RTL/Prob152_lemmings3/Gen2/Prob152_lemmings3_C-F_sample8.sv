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

    // Define states with descriptive names
    parameter WALK_L = 3'b000;
    parameter WALK_R = 3'b001;
    parameter FALL_L = 3'b010;
    parameter FALL_R = 3'b011;
    parameter DIG_L  = 3'b100;
    parameter DIG_R  = 3'b101;

    reg [2:0] state, next_state;

    // State transition with strict priority
    always @(*) begin
        case (state)
            WALK_L: begin
                if (~ground)      next_state = FALL_L;
                else if (dig)    next_state = DIG_L;
                else if (bump_left) next_state = WALK_R;
                else             next_state = WALK_L;
            end
            WALK_R: begin
                if (~ground)      next_state = FALL_R;
                else if (dig)    next_state = DIG_R;
                else if (bump_right) next_state = WALK_L;
                else             next_state = WALK_R;
            end
            FALL_L: next_state = ground ? WALK_L : FALL_L;
            FALL_R: next_state = ground ? WALK_R : FALL_R;
            DIG_L:  next_state = ground ? DIG_L  : FALL_L;
            DIG_R:  next_state = ground ? DIG_R  : FALL_R;
            default: next_state = WALK_L;
        endcase
    end

    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) state <= WALK_L;
        else state <= next_state;
    end

    // Optimized output logic
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALL_L) || (state == FALL_R);
    assign digging = (state == DIG_L) || (state == DIG_R);

endmodule