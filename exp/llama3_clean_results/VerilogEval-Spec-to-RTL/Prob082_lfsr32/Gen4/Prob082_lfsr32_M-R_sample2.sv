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
        next_state[31] = q_reg[0] ^ q_reg[21] ^ q_reg[1] ^ q_reg[30]; // XOR for the MSB considering taps
        for (int i = 30; i >= 1; i--) begin
            // Shift right for non-tap positions
            if (i == 21 || i == 1) begin
                next_state[i] = q_reg[i-1] ^ q_reg[0]; // Apply XOR for tap positions
            end else if (i == 0) begin
                next_state[i] = q_reg[31]; // Feedback from MSB
            end else begin
                next_state[i] = q_reg[i-1]; // Simple shift right for non-tap positions
            end
        end
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule