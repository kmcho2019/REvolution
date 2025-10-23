module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [4:0] shift_reg; // 5-bit shift register

// Clock gating signal
reg clk_gated;

// Clock gating logic
always @(*) begin
    if (RST || (shift_reg!= 5'b10011)) begin
        clk_gated = 1'b0;
    end else begin
        clk_gated = 1'b1;
    end
end

// Shift register logic with reset and clock gating
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b00000; // Reset shift register
    end else if (clk_gated) begin
        shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
    end
end

// Continuous assignment for MATCH signal
assign MATCH = (shift_reg == 5'b10011)? 1'b1 : 1'b0;

endmodule