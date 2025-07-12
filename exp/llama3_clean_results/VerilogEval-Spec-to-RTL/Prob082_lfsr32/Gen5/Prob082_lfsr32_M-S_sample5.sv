module TopModule(
    input  clk,
    input  reset,
    output [31:0] q
);

reg [31:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 32'h1; // Reset to 32'h1
    end else begin
        // Calculate new MSB as XOR of tapped bits and LSB
        q_reg <= {q_reg[30:0], q_reg[31] ^ q_reg[21] ^ q_reg[1] ^ q_reg[0]};
    end
end

assign q = q_reg;

endmodule