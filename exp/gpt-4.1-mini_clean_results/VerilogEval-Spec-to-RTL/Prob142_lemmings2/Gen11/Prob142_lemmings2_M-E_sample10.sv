module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    typedef enum logic [1:0] {
        LEFT    = 2'b00,
        RIGHT   = 2'b01,
        FALLING = 2'b10
    } state_t;

    state_t state, next_state;

    always @(*) begin
        case (state)
            LEFT: begin
                if (!ground)
                    next_state = FALLING;
                else if (bump_left || bump_right) // bump from either side flips direction to right
                    next_state = RIGHT;
                else
                    next_state = LEFT;
            end
            RIGHT: begin
                if (!ground)
                    next_state = FALLING;
                else if (bump_left || bump_right) // bump flips direction to left
                    next_state = LEFT;
                else
                    next_state = RIGHT;
            end
            FALLING: begin
                if (ground) begin
                    // return to previous walking direction
                    // Use low bit of state to represent previous direction:
                    // For FALLING state, store direction in lsb: 0=LEFT,1=RIGHT (retain direction)
                    // We'll store direction in bit 0 of state, so keep state[0]
                    if (state[0] == 1'b0)
                        next_state = LEFT;
                    else
                        next_state = RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end
            default: next_state = LEFT;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end else begin
            if (state == FALLING && !ground) begin
                // keep direction bit from previous walking state in LSB of state during FALLING
                // so preserve state[0]
                state <= FALLING;
            end else if (state == FALLING && ground) begin
                // next_state logic already sets walking state with correct direction
                state <= next_state;
            end else if (!ground) begin
                // falling starts, store direction bit in state[0]
                // current direction bit = state[0]
                state <= {1'b1, state[0]}; // FALLING with direction bit in LSB
            end else begin
                // walking states update normally
                state <= next_state;
            end
        end
    end

    assign aaah       = (state[1] == 1'b1);        // FALLING if MSB=1
    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule