module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// 5-bit shift register to store the last five inputs
reg [4:0] shift_reg;

// Internal signal to store the current state of the shift register
reg [4:0] current_state;

// Clock enable signal to reduce switching activity
reg clock_enable;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Initialize the shift register and MATCH signal on reset
        shift_reg <= 5'b00000;
        MATCH <= 1'b0;
    end else begin
        // Update the shift register on every clock cycle
        shift_reg <= {IN, shift_reg[4:1]};
        
        // Check if the current state of the shift register matches the target sequence
        current_state <= shift_reg;
        
        // Assign the MATCH signal based on the comparison result
        MATCH <= (current_state == 5'b10011)? 1'b1 : 1'b0;
    end
end

endmodule