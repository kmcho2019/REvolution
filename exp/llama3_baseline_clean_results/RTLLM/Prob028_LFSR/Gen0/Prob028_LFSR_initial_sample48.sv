module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] out_reg;

always @(posedge clk) begin
    if (rst) begin
        out_reg <= 4'd0; // Reset the register to zero when rst is high
    end else begin
        // Calculate the feedback signal by XORing the MSB and the second MSB, then inverting it
        reg feedback;
        assign feedback = ~(out_reg[3] ^ out_reg[2]);
        
        // Shift the bits left and insert the feedback at the LSB
        out_reg <= {out_reg[2:0], feedback};
    end
end

assign out = out_reg;

endmodule