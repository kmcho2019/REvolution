module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// State encoding: tracks progress toward 1001 pattern
// state[0] = got '1'
// state[1] = got '10'
// state[2] = got '100'
reg [2:0] state;

// Next state logic (combinational)
wire next_state_0 = data_in;                            // Capture '1'
wire next_state_1 = state[0] & ~data_in;                // Capture '10'
wire next_state_2 = state[1] & ~data_in;                // Capture '100'

// State update (sequential)
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= 3'b0;
    end else begin
        state <= {next_state_2, next_state_1, next_state_0};
    end
end

// Output generation (combinational)
assign sequence_detected = state[2] & data_in;  // Detect final '1' in '1001'

endmodule