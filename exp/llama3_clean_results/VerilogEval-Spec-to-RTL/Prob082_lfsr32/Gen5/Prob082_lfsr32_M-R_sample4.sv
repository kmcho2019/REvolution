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
        // Calculate the MSB based on the XOR of LSB and tapped bits
        next_state[31] = q_reg[0] ^ q_reg[21] ^ q_reg[1] ^ q_reg[30];
        
        // Shift right for non-tap positions
        for (int i = 30; i > 0; i--) begin
            if (i == 21 || i == 1) begin
                // Apply XOR for tap positions
                next_state[i] = q_reg[i-1] ^ q_reg[0];
            end else begin
                next_state[i] = q_reg[i-1];
            end
        end
        
        // Feedback from MSB for LSB
        next_state[0] = q_reg[31];
        
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule