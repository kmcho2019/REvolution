module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output [3:0] out // 4-bit output representing the current state of the LFSR
);

reg [3:0] state; // Variable to hold the current state of the LFSR

// Sequential logic block to update the LFSR state
always @ (posedge clk or posedge rst) begin
    if (rst) begin // If reset is high, initialize the register to zero
        state <= 4'b0;
    end else begin // Otherwise, shift the bits left and insert the new feedback value at the LSB
        state <= {state[2:0], ~(state[3] ^ state[2])};
    end
end

assign out = state;

endmodule