module TopModule(
    input  clk,
    input  reset,
    output [31:0] q
);

reg [31:0] q_reg;
reg [31:0] next_q;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 32'h1;
    end else begin
        q_reg <= next_q;
    end
end

always @(*) begin
    next_q = q_reg >> 1; // Shift right
    next_q[31] = q_reg[0] ^ q_reg[1] ^ q_reg[2] ^ q_reg[22]; // Update MSB based on taps
end

assign q = q_reg;

endmodule