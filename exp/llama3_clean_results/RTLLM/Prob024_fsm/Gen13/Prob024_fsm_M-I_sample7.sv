module fsm(
    input logic IN, // Input signal to the FSM
    input logic CLK, // Clock signal used for synchronous operation
    input logic RST, // Reset signal to initialize the FSM
    output logic MATCH // Output signal indicating a match condition based on the FSM state
);

// 5-bit shift register to hold the last 5 input bits
logic [4:0] shift_reg;

// Sequential logic for shift register
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset shift register on RST
        shift_reg <= 5'b00000;
    end else begin
        // Shift in new input bit
        shift_reg <= {shift_reg[3:0], IN};
    end
end

// Combinational logic for MATCH output
assign MATCH = (shift_reg == 5'b10011) ? 1'b1 : 1'b0;

endmodule