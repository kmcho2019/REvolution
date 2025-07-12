module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // If reset is high, initialize the register to zero
        out <= 4'd0;
    end else begin
        // Calculate the feedback by XORing the MSB and the second MSB, then inverting the result
        reg [3:0] feedback;
        feedback[0] = ~(out[3] ^ out[2]);
        // Shift the bits left and insert the feedback at the LSB
        out <= {out[2:0], feedback[0]};
    end
end

endmodule