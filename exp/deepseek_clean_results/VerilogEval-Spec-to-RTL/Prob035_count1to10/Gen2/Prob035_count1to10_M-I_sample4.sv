module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [9:0] state; // One-hot states for 1-10 (bit 0 = state 1, bit 9 = state 10)

// Next state logic (shift register with wrap-around)
always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001; // Reset to state 1
    end
    else begin
        state <= {state[8:0], state[9]}; // Rotate left
    end
end

// Convert one-hot to binary output
assign q = (state[0] ? 4'd1  :
           (state[1] ? 4'd2  :
           (state[2] ? 4'd3  :
           (state[3] ? 4'd4  :
           (state[4] ? 4'd5  :
           (state[5] ? 4'd6  :
           (state[6] ? 4'd7  :
           (state[7] ? 4'd8  :
           (state[8] ? 4'd9  :
           4'd10)))))))));

endmodule