module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [4:0] shift_reg = 5'b00000;
reg clk_gated;

// Clock gating to reduce power consumption
always @(posedge CLK or posedge RST)
    if (RST) begin
        clk_gated <= 1'b0;
        shift_reg <= 5'b00000;
    end else if (!clk_gated && IN != 1'b0) begin
        clk_gated <= 1'b1;
    end else if (clk_gated && IN == 5'b10011) begin
        clk_gated <= 1'b0;
    end

// Update shift register only when clock is gated
always @(posedge CLK)
    if (clk_gated) begin
        shift_reg <= {IN, shift_reg[4:1]};
    end

assign MATCH = shift_reg == 5'b10011;

endmodule