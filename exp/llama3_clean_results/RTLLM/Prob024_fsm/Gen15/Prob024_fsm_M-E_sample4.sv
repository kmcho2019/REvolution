module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Define the length of the sequence
parameter SEQUENCE_LENGTH = 5;

// Shift register to store the last SEQUENCE_LENGTH bits
logic [SEQUENCE_LENGTH-1:0] shift_register;

// Reset signal to initialize the shift register
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_register <= {SEQUENCE_LENGTH{1'b0}};
    end else begin
        shift_register <= {IN, shift_register[SEQUENCE_LENGTH-1:1]};
    end
end

// Comparator to match the shift register contents with the target sequence
always_comb begin
    MATCH = 1'b0;  // Default: no match
    
    // Define the target sequence
    logic [SEQUENCE_LENGTH-1:0] target_sequence = 5'b10011;
    
    // Compare the shift register contents with the target sequence
    if (shift_register == target_sequence) begin
        MATCH = 1'b1;  // Set MATCH to 1 if the sequence matches
    end
end

endmodule