module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// 5-bit shift register to store the last 5 input bits
logic [4:0] shift_reg;

// Asynchronous reset
always @(RST or posedge CLK) begin
    if (RST) begin
        shift_reg <= 5'b00000;
        MATCH <= 1'b0;
    end else begin
        // Shift the input bit into the register
        shift_reg <= {IN, shift_reg[4:1]};
        
        // Check the contents of the register against the target sequence
        if (shift_reg == 5'b10011) begin
            MATCH <= 1'b1;
        end else begin
            MATCH <= 1'b0;
        end
    end
end

endmodule