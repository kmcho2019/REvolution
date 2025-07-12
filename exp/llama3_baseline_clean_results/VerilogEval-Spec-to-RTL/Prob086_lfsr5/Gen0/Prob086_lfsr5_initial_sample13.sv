module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q_reg;

always @(posedge clk) begin
    if(reset) begin
        q_reg <= 16; // Initialize to 10000 in binary (1 in the MSB position)
    end else begin
        q_reg[0] <= q_reg[4] ^ q_reg[2] ^ q_reg[0]; // Update q[0] based on the XOR of q[4], q[2], and q[0]
        q_reg[1] <= q_reg[0]; // Shift right
        q_reg[2] <= q_reg[1] ^ q_reg[0]; // Update q[2] based on the XOR of q[1] and q[0]
        q_reg[3] <= q_reg[2]; // Shift right
        q_reg[4] <= q_reg[3] ^ q_reg[0]; // Update q[4] based on the XOR of q[3] and q[0]
    end
end

assign q = q_reg;

endmodule