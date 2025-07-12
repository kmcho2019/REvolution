module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

// Dual-buffer approach with extended boundary bits
reg [513:0] current_state;  // [513:512] and [1:0] are boundary guards (0)
reg [511:0] next_state;

// Output assignment
assign q = current_state[512:1];

// Boundary initialization and neighbor access
wire [513:0] extended_current = {1'b0, current_state[512:1], 1'b0};

always @(posedge clk) begin
    if (load) begin
        // Load new data into current state (with boundaries)
        current_state <= {1'b0, data, 1'b0};
    end else begin
        // Update current state from previously computed next state
        current_state <= {1'b0, next_state, 1'b0};
    end
end

// Parallel next state computation
always @(*) begin
    for (integer i = 0; i < 512; i = i + 1) begin
        // Each next state is XOR of left and right neighbors
        // Neighbors are always in positions i and i+2 due to extended register
        next_state[i] = extended_current[i] ^ extended_current[i+2];
    end
end

endmodule