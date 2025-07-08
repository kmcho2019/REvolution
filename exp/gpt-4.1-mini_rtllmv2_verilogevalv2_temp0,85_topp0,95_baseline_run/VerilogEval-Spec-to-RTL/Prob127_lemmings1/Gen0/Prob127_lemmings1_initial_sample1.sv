module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    output reg  walk_left,
    output reg  walk_right
);

    typedef enum logic [0:0] {
        WALK_LEFT  = 1'b0,
        WALK_RIGHT = 1'b1
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            WALK_LEFT: begin
                if (bump_left || bump_right)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (bump_left || bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // State register with async posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Moore output logic
    always @(*) begin
        walk_left  = (state == WALK_LEFT);
        walk_right = (state == WALK_RIGHT);
    end

endmodule