module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire        train_valid,
    input  wire        train_taken,
    output reg  [1:0]  state
);

    wire [1:0] next_state;
    wire       update_enable;

    assign update_enable = train_valid;

    // Compute next_state with saturation between 0 and 3
    // Use min/max style saturation with conditional expressions
    assign next_state = (update_enable) ?
        (train_taken ?
            (state == 2'd3 ? 2'd3 : state + 2'd1) :
            (state == 2'd0 ? 2'd0 : state - 2'd1)
        ) : state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // reset to weakly not-taken
        end else if (update_enable && (state != next_state)) begin
            state <= next_state; // update only if changed to reduce toggling
        end
        // else hold current state
    end

endmodule