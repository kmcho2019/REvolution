module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    output reg  walk_left,
    output reg  walk_right
);

    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // Register to detect rising edge of areset
    reg areset_d;
    wire reset_pulse;

    always @(posedge clk or posedge areset) begin
        if (areset)
            areset_d <= 1'b1;
        else
            areset_d <= 1'b0;
    end

    // Reset pulse when areset rises from 0 to 1
    assign reset_pulse = areset & ~areset_d;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            WALK_LEFT:  next_state = (bump_left || bump_right) ? WALK_RIGHT : WALK_LEFT;
            WALK_RIGHT: next_state = (bump_left || bump_right) ? WALK_LEFT  : WALK_RIGHT;
            default:    next_state = WALK_LEFT;
        endcase
    end

    // State register with synchronous reset pulse triggered on areset rising edge
    always @(posedge clk) begin
        if (reset_pulse)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Output logic (Moore outputs depend on state only)
    always @(*) begin
        case(state)
            WALK_LEFT: begin
                walk_left  = 1'b1;
                walk_right = 1'b0;
            end
            WALK_RIGHT: begin
                walk_left  = 1'b0;
                walk_right = 1'b1;
            end
            default: begin
                walk_left  = 1'b1;
                walk_right = 1'b0;
            end
        endcase
    end

endmodule