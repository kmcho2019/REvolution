module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] state;                  // Internal state variable

// Sequential logic for state machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset state on reset
        state <= 2'b00;
    end else if (state == 2'b11) begin
        // If state has reached 3, reset state
        state <= 2'b00;
    end else begin
        // Otherwise, increment state
        state <= state + 1'b1;
    end
end

// Assign valid signal and output based on state
assign valid_out = (state == 2'b00);
assign dout = d[3 - state];

endmodule