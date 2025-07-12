module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    // Compute next state using saturating arithmetic with min/max
    wire [2:0] next_state_plus = state + 1;
    wire [2:0] next_state_minus = state - 1;
    wire [1:0] next_state_inc = (next_state_plus > 3) ? 2'b11 : next_state_plus[1:0];
    wire [1:0] next_state_dec = (next_state_minus[2] == 1'b1) ? 2'b00 : next_state_minus[1:0]; // check sign bit for underflow

    wire [1:0] next_state = train_valid ? (train_taken ? next_state_inc : next_state_dec) : state;
    wire update_enable = train_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else if (update_enable) begin
            state <= next_state;
        end
        // else hold state
    end

endmodule