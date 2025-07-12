module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

logic [4:0] shift_reg; // 5-bit shift register to hold the last 5 input bits

// Create a shift register effect using assign statements
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_reg <= 5'b00000; // Reset shift register on RST
    end else begin
        shift_reg <= {shift_reg[3:0], IN}; // Shift in new input bit
    end
end

// Alternative implementation of the shift register using assign
// However, this is not synthesizable for sequential logic
// assign shift_reg = (RST)? 5'b00000 : {shift_reg[3:0], IN};

// Combinational logic for MATCH output remains the same
assign MATCH = (shift_reg == 5'b10011)? 1'b1 : 1'b0;

endmodule