module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

// State transition lookup table for 5-bit maximal-length LFSR with taps at 5 and 3
reg [4:0] next_state [0:31];

integer i;
initial begin
    // Initialize all states to 0 (won't be used except for simulation)
    for (i = 0; i < 32; i = i + 1)
        next_state[i] = 5'b00000;
    
    // Define valid state transitions (31 states)
    next_state[5'b00001] = 5'b10000;
    next_state[5'b00010] = 5'b01000;
    next_state[5'b00011] = 5'b11000;
    next_state[5'b00100] = 5'b00100;
    next_state[5'b00101] = 5'b10100;
    next_state[5'b00110] = 5'b01100;
    next_state[5'b00111] = 5'b11100;
    next_state[5'b01000] = 5'b00010;
    next_state[5'b01001] = 5'b10010;
    next_state[5'b01010] = 5'b01010;
    next_state[5'b01011] = 5'b11010;
    next_state[5'b01100] = 5'b00110;
    next_state[5'b01101] = 5'b10110;
    next_state[5'b01110] = 5'b01110;
    next_state[5'b01111] = 5'b11110;
    next_state[5'b10000] = 5'b00001;
    next_state[5'b10001] = 5'b10001;
    next_state[5'b10010] = 5'b01001;
    next_state[5'b10011] = 5'b11001;
    next_state[5'b10100] = 5'b00101;
    next_state[5'b10101] = 5'b10101;
    next_state[5'b10110] = 5'b01101;
    next_state[5'b10111] = 5'b11101;
    next_state[5'b11000] = 5'b00011;
    next_state[5'b11001] = 5'b10011;
    next_state[5'b11010] = 5'b01011;
    next_state[5'b11011] = 5'b11011;
    next_state[5'b11100] = 5'b00111;
    next_state[5'b11101] = 5'b10111;
    next_state[5'b11110] = 5'b01111;
    next_state[5'b11111] = 5'b11111; // Should never be reached in maximal-length LFSR
end

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= next_state[q];
    end
end

endmodule