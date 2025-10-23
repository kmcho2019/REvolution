module TopModule(
    input clk,
    input reset,
    output [31:0] q
);

reg [31:0] q_reg;
reg [31:0] next_q;

always @(*) begin
    next_q = q_reg;
    next_q[31] = q_reg[31] ^ q_reg[0];
    next_q[21] = q_reg[21] ^ q_reg[0];
    next_q[1] = q_reg[1] ^ q_reg[0];
    next_q[0] = q_reg[0] ^ q_reg[0];
end

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 32'h1;
    end else begin
        q_reg <= next_q;
    end
end

assign q = q_reg;

endmodule