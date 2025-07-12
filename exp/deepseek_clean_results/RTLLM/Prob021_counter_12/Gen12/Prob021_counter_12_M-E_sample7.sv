module counter_12 (
    input wire rst_n,          // Active low reset (synchronous)
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output wire [3:0] out      // 4-bit counter output
);

// One-hot state encoding (12 states)
reg [11:0] state;

// State to output decoding
assign out = (state[0]  ? 4'd0  :
             state[1]  ? 4'd1  :
             state[2]  ? 4'd2  :
             state[3]  ? 4'd3  :
             state[4]  ? 4'd4  :
             state[5]  ? 4'd5  :
             state[6]  ? 4'd6  :
             state[7]  ? 4'd7  :
             state[8]  ? 4'd8  :
             state[9]  ? 4'd9  :
             state[10] ? 4'd10 :
                         4'd11);

always @(posedge clk) begin
    if (!rst_n) begin
        // Reset to state 0 (one-hot)
        state <= 12'b0000_0000_0001;
    end
    else if (valid_count) begin
        // Circular shift left for state transition
        state <= {state[10:0], state[11]};
    end
    // else hold current state
end

endmodule