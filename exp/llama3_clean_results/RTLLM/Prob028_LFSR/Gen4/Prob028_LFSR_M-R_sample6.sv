module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Continuous assignment is not needed here since we directly calculate within the always block
// Instead, we focus on the clocked always block for state update

always @ (posedge clk) begin
    if (rst) begin
        // Synchronous reset: set out to 0 when rst is high
        out <= 4'd0;
    end else begin
        // Update out based on its current value
        // The new most significant bit (MSB) is the inverted XOR of the current MSB and the second MSB
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule