module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State encoding
    localparam WALK_LEFT  = 1'b0,
               WALK_RIGHT = 1'b1;

    reg state, next_state;

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        if (bump_left | bump_right)
            next_state = ~state; // toggle state when bump on either side
        else
            next_state = state;
    end

    // Registered outputs synchronous to clock for glitch-free outputs
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left  <= 1'b1;
            walk_right <= 1'b0;
        end else begin
            case (state)
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