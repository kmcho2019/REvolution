module TopModule(
    input  clk,
    input  reset,
    output [31:0] q
);

reg [31:0] q_reg;
reg [31:0] q_next;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 32'h1;
    end else begin
        q_reg <= q_next;
    end
end

assign q = q_reg;

integer i;
always @(*) begin
    q_next = {q_reg[30:0], 1'b0}; // Initialize next state with current state shifted to the right
    if (q_reg[0] == 1'b1) begin // If LSB is 1, apply XOR operation at tap positions
        if (q_reg[21] == 1'b1) q_next[0] ^= 1'b1; // Tap at bit position 22
        if (q_reg[1] == 1'b1) q_next[0] ^= 1'b1; // Tap at bit position 2
        if (q_reg[0] == 1'b1) q_next[0] ^= 1'b1; // Tap at bit position 1
    end
end

endmodule