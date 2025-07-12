module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // Movement states (direction)
    parameter MOVE_LEFT = 1'b0;
    parameter MOVE_RIGHT = 1'b1;
    reg move_state;

    // Action states
    parameter ACT_WALK = 2'b00;
    parameter ACT_FALL = 2'b01;
    parameter ACT_DIG  = 2'b10;
    reg [1:0] act_state;

    // Edge detection for ground
    reg ground_prev;
    wire ground_falling = ~ground & ground_prev;
    wire ground_rising = ground & ~ground_prev;

    // Next state signals
    reg next_move_state;
    reg [1:0] next_act_state;

    // Movement state machine (parallel evaluation)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            move_state <= MOVE_LEFT;
            ground_prev <= 1'b1;
        end else begin
            move_state <= next_move_state;
            ground_prev <= ground;
        end
    end

    // Action state machine (parallel evaluation)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            act_state <= ACT_WALK;
        end else begin
            act_state <= next_act_state;
        end
    end

    // Movement transitions
    always @(*) begin
        next_move_state = move_state;
        if (act_state == ACT_WALK) begin
            case ({bump_left, bump_right})
                2'b10: next_move_state = MOVE_RIGHT;
                2'b01: next_move_state = MOVE_LEFT;
                default: next_move_state = move_state;
            endcase
        end
    end

    // Action transitions with explicit priority
    always @(*) begin
        next_act_state = act_state;
        case (act_state)
            ACT_WALK: begin
                if (ground_falling) next_act_state = ACT_FALL;
                else if (dig & ground) next_act_state = ACT_DIG;
                else next_act_state = ACT_WALK;
            end
            ACT_FALL: if (ground_rising) next_act_state = ACT_WALK;
            ACT_DIG: if (ground_falling) next_act_state = ACT_FALL;
        endcase
    end

    // Pipelined output generation
    always @(posedge clk) begin
        walk_left <= (act_state == ACT_WALK) & (move_state == MOVE_LEFT);
        walk_right <= (act_state == ACT_WALK) & (move_state == MOVE_RIGHT);
        aaah <= (act_state == ACT_FALL);
        digging <= (act_state == ACT_DIG);
    end

endmodule