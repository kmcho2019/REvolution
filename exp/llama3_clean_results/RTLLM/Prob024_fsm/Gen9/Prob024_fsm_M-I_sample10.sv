module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [4:0] shift_reg; // 5-bit shift register

// Shift register logic with clock gating
reg clk_enable;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        shift_reg <= 5'b00000; // Reset shift register
        clk_enable <= 1'b0;
    end else if (IN != shift_reg[0]) begin
        shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
        clk_enable <= 1'b1;
    end else begin
        clk_enable <= 1'b0;
    end
end

// Combinational logic for MATCH signal
assign MATCH = (shift_reg == 5'b10011)? 1'b1 : 1'b0;

// Clock gating
wire gated_clk;
assign gated_clk = clk_enable ? CLK : 1'b0;

// Use gated clock for shift register logic
always @(posedge gated_clk or posedge RST) begin
    if(RST) begin
        shift_reg <= 5'b00000; // Reset shift register
    end else begin
        shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
    end
end

endmodule