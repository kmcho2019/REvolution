module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire fb; // feedback bit from output bit q[0]
assign fb = q[0];

// Compute next state bits for Galois LFSR with taps at bit 5 (q[4]) and 3 (q[2])
wire [4:0] next_q;

assign next_q[0] = q[1];
assign next_q[1] = q[2];
assign next_q[2] = q[3] ^ fb;   // tap at bit 3 -> XOR with feedback
assign next_q[3] = q[4];
assign next_q[4] = fb;           // tap at bit 5 -> XOR with feedback (in Galois LFSR, MSB gets fb)

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= next_q;
end

endmodule