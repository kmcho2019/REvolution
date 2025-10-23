module LFSR (
    input clk, 
    input rst, 
    output [3:0] out
);

reg [3:0] out_reg;

always @ (posedge clk) begin
    if (rst) begin
        out_reg <= 4'd0; // Initialize register to zero on reset
    end else begin
        // Calculate feedback signal by XORing MSB and second MSB, then inverting
        reg feedback;
        assign feedback = ~(out_reg[3] ^ out_reg[2]);
        
        // Shift bits left and insert new feedback value at LSB
        out_reg <= {out_reg[2:0], feedback};
    end
end

assign out = out_reg;

endmodule