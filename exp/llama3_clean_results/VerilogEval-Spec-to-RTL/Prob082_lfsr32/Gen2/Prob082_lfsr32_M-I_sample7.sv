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
        // Calculate next state by shifting right and applying XOR for taps
        reg [31:0] q_next;
        q_next = {q_reg[31] ^ q_reg[21] ^ q_reg[1] ^ q_reg[0], q_reg[31:1]};
        q_reg <= q_next;
    end
end

assign q = q_reg;

endmodule