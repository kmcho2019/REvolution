module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// 5-bit shift register to store the last 5 input bits
logic [4:0] shift_reg;

// Sequential logic for the shift register
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b00000;
    end else begin
        shift_reg <= {shift_reg[3:0], IN};
    end
end

// Combinational logic to compare the shift register with the target sequence
assign MATCH = (shift_reg == 5'b10011) ? 1'b1 : 1'b0;

endmodule