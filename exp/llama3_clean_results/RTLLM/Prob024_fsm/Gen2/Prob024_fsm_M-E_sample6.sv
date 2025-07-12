module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define the target sequence
parameter TARGET_SEQ = 5'b10011;

// Shift register to hold the input sequence
reg [4:0] shift_register;

// Load the input into the shift register
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_register <= 5'b00000;
    end else begin
        shift_register <= {shift_register[3:0], IN};
    end
end

// Check if the shift register contents match the target sequence
always_comb begin
    MATCH = (shift_register == TARGET_SEQ) ? 1'b1 : 1'b0;
end

endmodule