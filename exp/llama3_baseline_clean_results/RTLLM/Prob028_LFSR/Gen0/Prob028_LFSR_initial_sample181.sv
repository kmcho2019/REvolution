module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state; // 4-bit register to store the LFSR state
assign out = state; // Continuously output the current state

always @(posedge clk or posedge rst) begin
    if (rst) begin // Reset the LFSR if reset signal is high
        state <= 4'd0;
    end else begin // Otherwise, shift the bits and insert the feedback
        state <= {state[2:0], ~(state[3] ^ state[2])}; // Shift left and insert feedback at LSB
    end
end

endmodule