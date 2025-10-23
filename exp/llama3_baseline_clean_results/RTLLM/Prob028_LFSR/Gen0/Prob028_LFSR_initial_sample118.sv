module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (rst) begin
        // Reset the register to zero when rst is high
        out <= 4'd0;
    end else begin
        // Calculate the feedback signal by XORing the MSB and the second MSB
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits left and insert the feedback at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule