module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback;
wire [4:0] next_q;

// Calculate feedback bit as XOR of q[0] and taps q[4] and q[2]
// For Galois LFSR, feedback = q[0]
assign feedback = q[0];

// Compute next state bits applying feedback to taps (bit 5 = q[4], bit 3 = q[2])
assign next_q[0] = q[1];
assign next_q[1] = q[2];
assign next_q[2] = q[3] ^ feedback;  // tap at bit 3
assign next_q[3] = q[4];
assign next_q[4] = feedback;          // tap at bit 5

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= next_q;
end

endmodule