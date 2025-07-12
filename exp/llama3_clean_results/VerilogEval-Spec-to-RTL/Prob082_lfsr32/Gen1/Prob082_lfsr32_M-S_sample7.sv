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
        reg [31:0] next_state;
        next_state = q_reg >> 1;
        next_state[31] = q_reg[0] ^ q_reg[22] ^ q_reg[2] ^ q_reg[1];
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule