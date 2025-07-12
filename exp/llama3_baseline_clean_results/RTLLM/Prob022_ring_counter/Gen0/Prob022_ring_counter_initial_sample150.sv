module ring_counter(
    input  logic       clk,    // Clock signal
    input  logic       reset,  // Reset signal
    output logic [7:0] out     // 8-bit output
);

logic [7:0] state;  // Internal state

// Sequential logic description
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 8'b0000_0001;  // Initialize with LSB set to 1
    end else begin
        state <= {state[6:0], state[7]};  // Shift left and wrap around
    end
end

// Continuous assignment for output
assign out = state;

endmodule