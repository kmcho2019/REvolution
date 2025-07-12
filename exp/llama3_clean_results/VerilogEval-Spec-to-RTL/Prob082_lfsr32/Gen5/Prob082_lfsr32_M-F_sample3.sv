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
        q_reg[31] <= q_reg[30] ^ q_reg[0];
        q_reg[30] <= q_reg[29] ^ q_reg[0];
        q_reg[29] <= q_reg[28] ^ q_reg[0];
        q_reg[28:22] <= q_reg[27:21];
        q_reg[21] <= q_reg[20] ^ q_reg[0];
        q_reg[20:2] <= q_reg[19:1];
        q_reg[1] <= q_reg[0] ^ q_reg[0];
        q_reg[0] <= q_reg[0] ^ q_reg[0];
    end
end

assign q = q_reg;

endmodule