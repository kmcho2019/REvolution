module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q_reg;

initial q_reg = 5'b10000; // Initial value, all zeros except for the most significant bit

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q_reg <= 5'b00001; // Reset to 1
    end else begin
        q_reg[4] <= q_reg[3] ^ q_reg[0]; // Position 5 (MSB) tapped
        q_reg[3] <= q_reg[2] ^ q_reg[0]; // Position 3 tapped
        q_reg[2] <= q_reg[1]; // Shift right
        q_reg[1] <= q_reg[0]; // Shift right
        q_reg[0] <= q_reg[4]; // Shift right
    end
end

assign q = q_reg;

endmodule