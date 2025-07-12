module TopModule (
    input clk,
    input reset,
    output reg [4:0] q = 5'b00001
);

// LUT for next state computation (Galois LFSR with taps at 5 and 3)
reg [4:0] next_state [0:31];

initial begin
    next_state[0]  = 5'b00000; // Invalid state (should never occur)
    next_state[1]  = 5'b10000;
    next_state[2]  = 5'b01000;
    next_state[3]  = 5'b10100;
    next_state[4]  = 5'b01010;
    next_state[5]  = 5'b10101;
    next_state[6]  = 5'b11010;
    next_state[7]  = 5'b01101;
    next_state[8]  = 5'b00110;
    next_state[9]  = 5'b10011;
    next_state[10] = 5'b11001;
    next_state[11] = 5'b11100;
    next_state[12] = 5'b01110;
    next_state[13] = 5'b00111;
    next_state[14] = 5'b00011;
    next_state[15] = 5'b10001;
    next_state[16] = 5'b11000;
    next_state[17] = 5'b01100;
    next_state[18] = 5'b00110;
    next_state[19] = 5'b10011;
    next_state[20] = 5'b11001;
    next_state[21] = 5'b11100;
    next_state[22] = 5'b01110;
    next_state[23] = 5'b00111;
    next_state[24] = 5'b00011;
    next_state[25] = 5'b10001;
    next_state[26] = 5'b11000;
    next_state[27] = 5'b01100;
    next_state[28] = 5'b00110;
    next_state[29] = 5'b10011;
    next_state[30] = 5'b11001;
    next_state[31] = 5'b11100;
end

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= next_state[q];
    end
end

endmodule