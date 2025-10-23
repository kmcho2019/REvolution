module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// 5-bit shift register to store input history
reg [4:0] shift_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b00000;
        MATCH <= 1'b0;
    end
    else begin
        // Shift in new bit and shift out oldest bit
        shift_reg <= {shift_reg[3:0], IN};
        
        // Parallel pattern matching
        MATCH <= (shift_reg == 5'b10011);
    end
end

endmodule