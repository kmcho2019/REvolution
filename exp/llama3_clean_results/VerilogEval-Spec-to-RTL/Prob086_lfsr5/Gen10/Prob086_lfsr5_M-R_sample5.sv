module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Calculate the next state for each bit in the LFSR
wire next_q_4, next_q_3, next_q_2, next_q_1, next_q_0;

// The most significant bit (MSB) is the result of XORing the bits at tap positions and the LSB
assign next_q_4 = q[4] ^ q[2] ^ q[0];
assign next_q_3 = q[3];
assign next_q_2 = q[2];
assign next_q_1 = q[1];
assign next_q_0 = q[0];

// Use a single always block to handle the sequential update
always @ (posedge clk) begin
    if (reset) begin
        // Reset q to a non-zero state with the LSB set
        q <= 5'b00001; 
    end else begin
        // Update the state of the LFSR
        q[4] <= next_q_4;
        q[3] <= next_q_3;
        q[2] <= next_q_2;
        q[1] <= next_q_1;
        q[0] <= next_q_0;
    end
end

// To implement the Galois LFSR shifting behavior
always @ (posedge clk) begin
    if (!reset) begin
        q <= {next_q_4, next_q_3, next_q_2, next_q_1, q[4]};
    end
end

endmodule