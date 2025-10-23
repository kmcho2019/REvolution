module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // Saturating increment (max 3) and decrement (min 0)
    wire [1:0] saturated_inc = (state == 2'd3) ? 2'd3 : (state + 2'd1);
    wire [1:0] saturated_dec = (state == 2'd0) ? 2'd0 : (state - 2'd1);

    // Next state logic: update only if train_valid is asserted
    wire [1:0] next_state = train_valid ? (train_taken ? saturated_inc : saturated_dec) : state;

    // Update enable to minimize toggling and save power
    wire update_enable = train_valid && (next_state != state);

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // Weakly not-taken reset state
        end else if (update_enable) begin
            state <= next_state;
        end
        // else hold current state without toggling
    end

endmodule