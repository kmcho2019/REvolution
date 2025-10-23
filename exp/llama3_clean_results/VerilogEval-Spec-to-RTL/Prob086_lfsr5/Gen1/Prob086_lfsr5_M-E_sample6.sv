module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q_reg;

initial q_reg = 5'b10001; // Initialize with a non-zero 5-bit value

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q_reg <= 5'b10001;
    end else begin
        q_reg[0] <= q_reg[4] ^ q_reg[2]; // Calculate new bit value
        q_reg[4] <= q_reg[3]; // Shift bits
        q_reg[3] <= q_reg[2];
        q_reg[2] <= q_reg[1];
        q_reg[1] <= q_reg[0];
    end
end

assign q = q_reg;

endmodule