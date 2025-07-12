module TopModule(
    input clk,
    input reset,
    output [31:0] q
);

reg [31:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 32'h1;
    end else begin
        reg [31:0] next_state;
        next_state[31] = q_reg[0] ^ q_reg[21] ^ q_reg[1]; // Corrected XOR for MSB
        for (int i = 30; i >= 1; i--) begin
            if (i == 21 || i == 1) begin
                next_state[i] = q_reg[i-1] ^ q_reg[0]; // Corrected tap positions
            end else begin
                next_state[i] = q_reg[i-1]; // Simple shift right
            end
        end
        next_state[0] = q_reg[31] ^ q_reg[0]; // Feedback from MSB to LSB
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule