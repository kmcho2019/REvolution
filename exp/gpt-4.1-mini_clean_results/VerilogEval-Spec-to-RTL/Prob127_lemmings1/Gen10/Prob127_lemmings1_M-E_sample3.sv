module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state;

    // Asynchronous positive edge reset FSM with outputs registered
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state     <= WALK_LEFT;
            walk_left <= 1'b1;
            walk_right<= 1'b0;
        end else begin
            // Determine next state based on bump inputs
            case ({bump_left, bump_right})
                2'b10: state <= WALK_RIGHT;            // bump left, walk right
                2'b01: state <= WALK_LEFT;             // bump right, walk left
                2'b11: state <= ~state;                // both bumps, toggle state
                default: state <= state;                // no bumps, hold state
            endcase
            // Update outputs as per new state (Moore)
            walk_left  <= (state == WALK_LEFT);
            walk_right <= (state == WALK_RIGHT);
        end
    end

endmodule