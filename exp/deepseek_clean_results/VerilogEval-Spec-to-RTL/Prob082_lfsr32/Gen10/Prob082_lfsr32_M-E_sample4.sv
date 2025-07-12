module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

reg [31:0] q_next;
reg [31:0] shadow_reg;
reg [1:0] xor_stage1; // Stores XOR results for taps 22 and 2

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
        shadow_reg <= 32'h1;
        xor_stage1 <= 2'b0;
    end else begin
        // First pipeline stage: compute XOR for taps 22 and 2
        xor_stage1[0] <= shadow_reg[22] ^ shadow_reg[0];
        xor_stage1[1] <= shadow_reg[2] ^ shadow_reg[0];
        
        // Second pipeline stage: compute final XOR and shift
        q <= {shadow_reg[0], shadow_reg[31:23], xor_stage1[0], 
              shadow_reg[21:3], xor_stage1[1], shadow_reg[1] ^ shadow_reg[0]};
              
        // Update shadow register with current q for next cycle
        shadow_reg <= q;
    end
end

endmodule