module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

// LUT for next state (5-bit Galois LFSR with taps at 5 and 3)
reg [4:0] next_state_lut [0:31];

initial begin
    // Initialize LUT with next states
    next_state_lut[0] = 0;  // unused (all zeros state)
    next_state_lut[1] = 5'b10100;
    next_state_lut[2] = 5'b01010;
    next_state_lut[3] = 5'b11011;
    next_state_lut[4] = 5'b11101;
    next_state_lut[5] = 5'b10110;
    next_state_lut[6] = 5'b01011;
    next_state_lut[7] = 5'b10001;
    next_state_lut[8] = 5'b11000;
    next_state_lut[9] = 5'b01100;
    next_state_lut[10] = 5'b00110;
    next_state_lut[11] = 5'b00011;
    next_state_lut[12] = 5'b10101;
    next_state_lut[13] = 5'b11110;
    next_state_lut[14] = 5'b01111;
    next_state_lut[15] = 5'b10011;
    next_state_lut[16] = 5'b10111;
    next_state_lut[17] = 5'b11011;
    next_state_lut[18] = 5'b10001;
    next_state_lut[19] = 5'b11000;
    next_state_lut[20] = 5'b01100;
    next_state_lut[21] = 5'b00110;
    next_state_lut[22] = 5'b00011;
    next_state_lut[23] = 5'b10101;
    next_state_lut[24] = 5'b11110;
    next_state_lut[25] = 5'b01111;
    next_state_lut[26] = 5'b10011;
    next_state_lut[27] = 5'b10111;
    next_state_lut[28] = 5'b11011;
    next_state_lut[29] = 5'b10001;
    next_state_lut[30] = 5'b11000;
    next_state_lut[31] = 5'b01100;
end

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Initialize to 1
    end
    else begin
        q <= next_state_lut[q];
    end
end

endmodule