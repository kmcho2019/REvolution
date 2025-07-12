module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];
wire [4:0] next;

// Construct next state vector:
// For tapped bits 4 and 2: next_bit = q[bit+1] XOR feedback
// For others: next_bit = q[bit+1]
// q[4] has no q[5], so feedback is XORed with 0 (i.e., just feedback XOR 0 = feedback applied at position 4)
assign next[0] = q[1];
assign next[1] = q[2];
assign next[2] = q[3] ^ feedback;  // tap at bit 3 (index 2)
assign next[3] = q[4];
assign next[4] = feedback;          // tap at bit 5 (index 4), feedback replaces shifted out bit

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= next;
end

endmodule