module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// Combined shift register and state encoding
// shift_reg[2] serves as state bit (0=IDLE, 1=WAIT_FOR_LAST_1)
// shift_reg[1:0] stores last two bits
reg [2:0] shift_reg;
reg shift_enable;  // Clock gating control

// Pre-compute partial matches
wire first_two_bits_match = (shift_reg[1:0] == 2'b10);
wire last_bit_match = (shift_reg[1:0] == 2'b00) && data_in;

always @(*) begin
    // Enable shift register only when needed
    shift_enable = !rst_n || !shift_reg[2] || data_in;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
        sequence_detected <= 1'b0;
    end
    else if (shift_enable) begin
        // Update shift register and state
        shift_reg <= {shift_reg[1], data_in, 
                     (shift_reg[1:0] == 2'b10 && data_in == 1'b0)};
    end

    // Pipelined output logic (registered)
    sequence_detected <= shift_reg[2] && data_in && (shift_reg[1:0] == 2'b00);
end

endmodule