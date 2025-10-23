module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [2:0] state; // IDLE, SEEN_1, SEEN_11, SEEN_110, SEEN_1101

// Combinational next state logic using assign
wire [2:0] next_state;
assign next_state = (state == 3'b000 && data == 1) ? 3'b001 :
                     (state == 3'b001 && data == 1) ? 3'b010 :
                     (state == 3'b010 && data == 0) ? 3'b011 :
                     (state == 3'b011 && data == 1) ? 3'b100 : // Transition to SEEN_1101 when sequence 1101 is detected
                     (state == 3'b100) ? 3'b100 : // Stay in SEEN_1101 state
                     3'b000; // Default to IDLE state

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to IDLE state
        start_shifting <= 0;
    end else begin
        state <= next_state;
        start_shifting <= (state == 3'b100); // Set start_shifting to 1 when in SEEN_1101 state
    end
end

endmodule