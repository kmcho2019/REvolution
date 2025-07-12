module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// 5-bit shift register to store the last 5 input bits
logic [4:0] shift_reg;

// Always block for sequential logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b00000;
        MATCH <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[3:0], IN};
        MATCH <= (shift_reg == 5'b10011) ? 1'b1 : 1'b0;
    end
end

endmodule