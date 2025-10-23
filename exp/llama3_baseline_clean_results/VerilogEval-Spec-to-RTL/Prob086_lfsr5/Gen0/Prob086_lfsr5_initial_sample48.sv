module TopModule(
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] q_reg; // internal register to hold the current state of the LFSR
reg [4:0] q_next; // next state of the LFSR

assign q = q_reg; // output the current state

// Compute next state
always @(*) begin
    // bits without taps simply shift right
    q_next[4] = q_reg[3];
    q_next[3] = q_reg[2];
    q_next[2] = q_reg[1];
    q_next[1] = q_reg[0];

    // tap positions: 4 (MSB) and 2
    // Since we are shifting right, the next value of bit 0 (LSB) is the XOR of the current MSB and bit 2
    q_next[0] = q_reg[4] ^ q_reg[2];
end

// Update state on positive edge of clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset to 1 (00001 in binary)
        q_reg <= 5'b00001;
    end else begin
        // Update state
        q_reg <= q_next;
    end
end

endmodule