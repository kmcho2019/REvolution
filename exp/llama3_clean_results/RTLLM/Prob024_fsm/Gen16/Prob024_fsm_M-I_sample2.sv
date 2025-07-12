module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [4:0] shift_reg; // 5-bit shift register
reg clk_enable; // Clock enable signal

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b00000; // Reset shift register
        MATCH <= 1'b0; // Reset MATCH signal
        clk_enable <= 1'b1; // Enable clock by default
    end else begin
        if (clk_enable) begin
            shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
            MATCH <= (shift_reg == 5'b10011) ? 1'b1 : 1'b0; // Update MATCH signal
            if (shift_reg == 5'b10011) begin
                clk_enable <= 'b0; // Disable clock when sequence is detected
            end else if (shift_reg[4] != IN) begin
                clk_enable <= 1'b; // Enable clock when input changes
            end
        end
    end
end

// Clock gating
wire gated_clk = clk_enable ? CLK :'b0;

// Use gated clock for shift register
always @(posedge gated_clk or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b00000; // Reset shift register
    end else begin
        shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
    end
end

endmodule