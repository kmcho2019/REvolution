module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state; // IDLE, SEEN_1, SEEN_11, SEEN_110
reg seen_1101; // Additional reg to track SEEN_1101 state

// Combinational next state logic using assign
wire [1:0] next_state;
assign next_state = (state == 2'b00 && data == 1) ? 2'b01 :
                     (state == 2'b01 && data == 1) ? 2'b10 :
                     (state == 2'b10 && data == 0) ? 2'b11 :
                     (state == 2'b11 && data == 1) ? 2'b01 : // Transition back to SEEN_1 if 1 is received after 110
                     2'b00; // Default to IDLE state

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to IDLE state
        seen_1101 <= 0; // Reset SEEN_1101 state
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == 2'b11 && data == 1) begin // Check for 1101 sequence
            seen_1101 <= 1;
        end
        start_shifting <= seen_1101;
    end
end

endmodule