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
        next_state[31] = q_reg[30] ^ q_reg[0]; // Tap at position 31
        next_state[21] = q_reg[20] ^ q_reg[0]; // Tap at position 21
        next_state[1] = q_reg[0] ^ q_reg[0]; // Tap at position 1, self-XOR doesn't change value
        next_state[0] = q_reg[31] ^ q_reg[0]; // Tap at position 0
        
        // No tap at other positions, simply shift right
        for (int i = 30; i > 21; i--) begin
            next_state[i] = q_reg[i-1];
        end
        
        for (int i = 20; i > 1; i--) begin
            next_state[i] = q_reg[i-1];
        end
        
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule