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
        q_reg <= {q_reg[30:0], q_reg[31] ^ q_reg[0]};
        
        // Tap at position 22 (21 in 0-indexed)
        q_reg[21] <= q_reg[20] ^ q_reg[0];
        
        // Tap at position 2 (1 in 0-indexed)
        q_reg[1] <= q_reg[0] ^ q_reg[0];
        
        // Tap at position 1 (0 in 0-indexed) is not needed as we are already calculating q_reg[0]
    end
end

assign q = q_reg;

endmodule