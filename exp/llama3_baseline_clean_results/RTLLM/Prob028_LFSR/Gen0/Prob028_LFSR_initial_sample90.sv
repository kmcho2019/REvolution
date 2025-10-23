module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

// Feedback calculation: XOR of the most significant bit and the second most significant bit, then inverted
assign out = state;
always @ (posedge clk) begin
    if (rst) begin
        // Reset the register to zero on active high reset
        state <= 4'd0;
    end else begin
        // Shift bits left and insert the new feedback value at the LSB
        state <= {state[2] ^ state[3], state[3:1]};
    end
end

endmodule