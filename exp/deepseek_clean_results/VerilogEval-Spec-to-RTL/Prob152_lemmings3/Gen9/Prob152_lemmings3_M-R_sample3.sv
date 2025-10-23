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
    parameter [2:0] 
        WALK_L = 3'b000,
        WALK_R = 3'b001,
        FALL_L = 3'b010,
        FALL_R = 3'b011,
        DIG_L  = 3'b100,
        DIG_R  = 3'b101;

    reg [2:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            WALK_L, WALK_R: begin
                if (~ground) begin
                    next_state = state[0] ? FALL_R : FALL_L;
                end else if (dig) begin
                    next_state = state[0] ? DIG_R : DIG_L;
                end else if (state[0] ? bump_left : bump_right) begin
                    next_state = state[0] ? WALK_L : WALK_R;
                end else begin
                    next_state = state;
                end
            end
            FALL_L, FALL_R: begin
                next_state = ground ? (state[0] ? WALK_R : WALK_L) : state;
            end
            DIG_L, DIG_R: begin
                if (~ground) begin
                    next_state = state[0] ? FALL_R : FALL_L;
                end else begin
                    next_state = state;
                end
            end
            default: next_state = WALK_L;
        endcase
    end

    // State update sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALL_L) || (state == FALL_R);
    assign digging = (state == DIG_L) || (state == DIG_R);

endmodule