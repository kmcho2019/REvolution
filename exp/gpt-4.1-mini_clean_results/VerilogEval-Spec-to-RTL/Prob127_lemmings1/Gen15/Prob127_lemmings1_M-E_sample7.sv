module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;

    reg [1:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        if (bump_left && bump_right) begin
            // Toggle state
            case (state)
                WALK_LEFT:  next_state = WALK_RIGHT;
                WALK_RIGHT: next_state = WALK_LEFT;
                default:    next_state = WALK_LEFT;
            endcase
        end else if (bump_left) begin
            next_state = WALK_RIGHT;
        end else if (bump_right) begin
            next_state = WALK_LEFT;
        end else begin
            next_state = state;
        end
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Output assignments based on state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule