module LFSR (
    input wire clk,        // 1-bit clock
    input wire rst,        // 1-bit active-high reset
    output wire [3:0] out  // 4-bit output (now as wire)
);

reg [3:0] state;           // Internal state register
wire feedback;             // Feedback wire

// Continuous assignment for feedback (XOR of two MSBs then inverted)
assign feedback = ~(state[3] ^ state[2]);

// Continuous assignment for output
assign out = state;

// Sequential block for state update
always @(posedge clk) begin
    if (rst) begin
        state <= 4'b0000;  // Synchronous reset
    end
    else begin
        // Shift left and insert feedback at LSB
        state <= {state[2:0], feedback};
    end
end

endmodule