module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];
wire [4:0] q_next;

assign q_next[4] = q[4] ^ feedback;  // tap at bit 5
assign q_next[3] = q[3];             // no tap
assign q_next[2] = q[2] ^ feedback;  // tap at bit 3
assign q_next[1] = q[1];             // no tap
assign q_next[0] = q[1];             // shift right

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= q_next;
end

endmodule