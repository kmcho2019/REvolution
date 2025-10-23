module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    output reg  walk_left,
    output reg  walk_right
);

    // State enumeration
    typedef enum logic {
        WALK_LEFT,
        WALK_RIGHT
    } state_t;

    state_t state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            WALK_LEFT:  next_state = (bump_left || bump_right) ? WALK_RIGHT : WALK_LEFT;
            WALK_RIGHT: next_state = (bump_left || bump_right) ? WALK_LEFT  : WALK_RIGHT;
            default:    next_state = WALK_LEFT;
        endcase
    end

    // State and output sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK_LEFT;
            walk_left  <= 1'b1;
            walk_right <= 1'b0;
        end else begin
            state <= next_state;

            // Moore outputs updated synchronously with state
            case (next_state)
                WALK_LEFT: begin
                    walk_left  <= 1'b1;
                    walk_right <= 1'b0;
                end
                WALK_RIGHT: begin
                    walk_left  <= 1'b0;
                    walk_right <= 1'b1;
                end
                default: begin
                    walk_left  <= 1'b1;
                    walk_right <= 1'b0;
                end
            endcase
        end
    end

endmodule