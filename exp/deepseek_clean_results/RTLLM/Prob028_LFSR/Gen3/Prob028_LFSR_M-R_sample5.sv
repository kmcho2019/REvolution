module LFSR (
    input wire clk,        // 1-bit clock
    input wire rst,        // 1-bit active-high reset
    output wire [3:0] out  // 4-bit output
);

reg [3:0] state;           // Internal state register

// Feedback calculation: XOR of two MSBs then inverted
wire feedback = ~(state[3] ^ state[2]);

// Output is directly connected to state
assign out = state;

// Sequential state update
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