module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire        train_valid,
    input  wire        train_taken,
    output reg  [1:0]  state
);

    // Next state calculation using saturating arithmetic
    wire [2:0] incr_state = (state < 3) ? (state + 1) : 3;  // saturate at max 3
    wire [2:0] decr_state = (state > 0) ? (state - 1) : 0;  // saturate at min 0

    wire [1:0] next_state = train_valid ?
                           (train_taken ? incr_state[1:0] : decr_state[1:0]) :
                           state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // weakly not-taken reset state
        else
            state <= next_state;
    end

endmodule