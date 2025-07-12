module TopModule(
    input  clk,
    input  reset,
    output [31:0] q
);

reg [31:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 32'h1;
    end else begin
        // Calculate the new MSB by XORing the tapped bits with the LSB
        reg new_msb;
        new_msb = q_reg[31] ^ q_reg[21] ^ q_reg[1] ^ q_reg[0];
        
        // Shift the bits to the right and insert the new MSB
        q_reg[31] <= new_msb;
        for (int i = 30; i >= 0; i--) begin
            q_reg[i] <= q_reg[i+1];
        end
    end
end

assign q = q_reg;

endmodule