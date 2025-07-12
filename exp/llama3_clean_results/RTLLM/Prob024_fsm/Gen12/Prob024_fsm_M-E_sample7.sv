module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [4:0] shift_reg; // 5-bit shift register

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b00000;
        MATCH <= 0;
    end else begin
        shift_reg <= {shift_reg[3:0], IN}; // Shift in the new input bit
        if (shift_reg == 5'b10011) begin // Check if the shift register contents match the target sequence
            MATCH <= 1;
        end else begin
            MATCH <= 0;
        end
    end
end

endmodule