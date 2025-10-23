module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state of the LFSR
);

// Sequential logic block to update the LFSR state
always @ (posedge clk or posedge rst) begin
    if (rst) begin // If reset is high, initialize the register to zero
        out <= 4'b0;
    end else begin // Otherwise, shift the bits left and insert the new feedback value at the LSB
        out <= {out[2:0], ~(out[3] ^ out[2])}; // Directly calculate and assign the new state
    end
end

endmodule