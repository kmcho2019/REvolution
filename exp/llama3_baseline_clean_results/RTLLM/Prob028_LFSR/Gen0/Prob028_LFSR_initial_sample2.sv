module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the LFSR to zero when the active high reset signal is asserted
        out <= 4'd0;
    end else begin
        // Calculate the feedback signal by XORing the MSB and the second MSB, then inverting the result
        reg [3:0] new_out;
        reg fb;
        fb = ~(out[3] ^ out[2]);
        
        // Shift the bits in the register left and insert the new feedback value at the LSB
        new_out[0] = fb;
        new_out[1] = out[0];
        new_out[2] = out[1];
        new_out[3] = out[2];
        
        out <= new_out;
    end
end

endmodule