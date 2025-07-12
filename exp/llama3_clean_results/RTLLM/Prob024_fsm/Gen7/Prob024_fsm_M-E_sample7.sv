module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define the target sequence
reg [4:0] target_sequence = 5'b10011;

// Use a 5-bit shift register to store the last 5 input bits
reg [4:0] shift_register;

// Initialize the shift register
always_ff @(posedge CLK or posedge RST) begin
    if(RST) begin
        shift_register <= 5'b0;
        MATCH <= 1'b0;
    end else begin
        // Shift in the new input bit
        shift_register <= {IN, shift_register[4:1]};
        // Compare the shift register with the target sequence
        MATCH <= (shift_register == target_sequence);
    end
end

endmodule