module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    wire [1:0] inc_val = (state < 2'd3) ? (state + 2'd1) : 2'd3;
    wire [1:0] dec_val = (state > 2'd0) ? (state - 2'd1) : 2'd0;

    // Determine next state based on training signals
    wire [1:0] candidate_state = train_taken ? inc_val : dec_val;

    // Update condition: update only if train_valid and candidate_state differs from current state
    wire update_enable = train_valid && (candidate_state != state);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // Weakly not-taken reset state
        end else if (update_enable) begin
            state <= candidate_state;
        end
        // else hold current state, avoiding toggles
    end

endmodule