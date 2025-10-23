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
    parameter WALK_L = 0;
    parameter WALK_R = 1;
    parameter DIG_L  = 2;
    parameter DIG_R  = 3;
    parameter FALL_L = 4;
    parameter FALL_R = 5;
    parameter SPLAT  = 6;

    reg [6:0] state;
    reg [4:0] fall_counter;

    // Next state and counter logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 1 << WALK_L;
            fall_counter <= 0;
        end else begin
            // Update fall counter
            if (state[FALL_L] || state[FALL_R]) begin
                fall_counter <= ground ? 0 : fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end

            // State transitions
            case (1'b1)
                state[WALK_L]: begin
                    state <= ~ground ? (1 << FALL_L) :
                           dig ? (1 << DIG_L) :
                           bump_left ? (1 << WALK_R) : (1 << WALK_L);
                end
                state[WALK_R]: begin
                    state <= ~ground ? (1 << FALL_R) :
                           dig ? (1 << DIG_R) :
                           bump_right ? (1 << WALK_L) : (1 << WALK_R);
                end
                state[DIG_L]: begin
                    state <= ~ground ? (1 << FALL_L) : (1 << DIG_L);
                end
                state[DIG_R]: begin
                    state <= ~ground ? (1 << FALL_R) : (1 << DIG_R);
                end
                state[FALL_L]: begin
                    state <= ground ? (fall_counter > 20 ? (1 << SPLAT) : (1 << WALK_L)) : (1 << FALL_L);
                end
                state[FALL_R]: begin
                    state <= ground ? (fall_counter > 20 ? (1 << SPLAT) : (1 << WALK_R)) : (1 << FALL_R);
                end
                state[SPLAT]: begin
                    state <= (1 << SPLAT);
                end
                default: begin
                    state <= (1 << WALK_L);
                end
            endcase
        end
    end

    // Output assignments
    assign walk_left = (state[WALK_L] | state[DIG_L] | state[FALL_L]) & ~state[SPLAT];
    assign walk_right = (state[WALK_R] | state[DIG_R] | state[FALL_R]) & ~state[SPLAT];
    assign aaah = state[FALL_L] | state[FALL_R];
    assign digging = state[DIG_L] | state[DIG_R];

endmodule