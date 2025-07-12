module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define the desired sequence as a parameter
parameter DESIRED_SEQ = 5'b10011;

// Initialize the shift register
reg [4:0] shift_reg;

// Update the shift register and the MATCH signal
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset the shift register and the MATCH signal
        shift_reg <= 5'b00000;
        MATCH <= 1'b0;
    end else begin
        // Update the shift register
        shift_reg <= {IN, shift_reg[4:1]};
        
        // Check if the shift register matches the desired sequence
        if (shift_reg == DESIRED_SEQ) begin
            // Assert the MATCH signal
            MATCH <= 1'b1;
        end else begin
            // Deassert the MATCH signal
            MATCH <= 1'b0;
        end
    end
end

endmodule