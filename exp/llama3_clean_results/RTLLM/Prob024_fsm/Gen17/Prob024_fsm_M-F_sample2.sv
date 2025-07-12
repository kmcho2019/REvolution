module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [4:0] shift_reg; // 5-bit shift register
reg clk_enable; // Clock enable signal for clock gating

// Simple and efficient reset logic
always @(posedge RST or posedge CLK) begin
    if (RST) begin
        // Reset shift register, MATCH signal, and clock enable
        shift_reg <= 5'b00000;
        MATCH <= 1'b0;
        clk_enable <= 1'b0;
    end else if (clk_enable) begin
        // Shift input sequence
        shift_reg <= {IN, shift_reg[4:1]};
        
        // Update MATCH signal based on the shift register content
        MATCH <= (shift_reg == 5'b10011)? 1'b1 : 1'b0;
    end
end

// Clock enable logic
always @(*) begin
    if (shift_reg == 5'b10011 || (shift_reg!= 5'b00000 && IN == 1'b1)) begin
        clk_enable = 1'b1;
    end else begin
        clk_enable = 1'b0;
    end
end

// Clock gating
wire clk_gated = clk_enable && CLK;

// Replace CLK with clk_gated in the always block
always @(posedge RST or posedge clk_gated) begin
    if (RST) begin
        // Reset shift register, MATCH signal, and clock enable
        shift_reg <= 5'b00000;
        MATCH <= 1'b0;
        clk_enable <= 1'b0;
    end else begin
        // Shift input sequence
        shift_reg <= {IN, shift_reg[4:1]};
        
        // Update MATCH signal based on the shift register content
        MATCH <= (shift_reg == 5'b10011)? 1'b1 : 1'b0;
    end
end

endmodule