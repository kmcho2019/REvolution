module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// 5-bit shift register to store the last 5 bits of the input sequence
logic [4:0] shift_reg;

// Asynchronous reset
always @(posedge RST) begin
    shift_reg <= 5'b00000;
    MATCH <= 1'b0;
end

// Synchronous logic
always_ff @(posedge CLK) begin
    if (RST) begin
        shift_reg <= 5'b00000;
        MATCH <= 1'b0;
    end else begin
        shift_reg <= {IN, shift_reg[4:1]};
    end
end

// Combinational logic
always_comb begin
    if (shift_reg == 5'b10011) begin
        MATCH = 1'b1;
    end else begin
        MATCH = 1'b0;
    end
end

endmodule