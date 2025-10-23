module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

// Custom increment pattern that counts 0-999 sequentially
// The pattern detects when to carry to higher bits
wire [9:0] next_q;
assign next_q[0] = reset ? 1'b0 : ~q[0];
assign next_q[1] = reset ? 1'b0 : (q[0] ? ~q[1] : q[1]);
assign next_q[2] = reset ? 1'b0 : ((&q[1:0]) ? ~q[2] : q[2]);
assign next_q[3] = reset ? 1'b0 : ((&q[2:0]) ? ~q[3] : q[3]);
assign next_q[4] = reset ? 1'b0 : ((&q[3:0]) ? ~q[4] : q[4]);
assign next_q[5] = reset ? 1'b0 : ((&q[4:0]) ? ~q[5] : q[5]);
assign next_q[6] = reset ? 1'b0 : ((&q[5:0]) ? ~q[6] : q[6]);
assign next_q[7] = reset ? 1'b0 : ((&q[6:0]) ? ~q[7] : q[7]);
assign next_q[8] = reset ? 1'b0 : ((&q[7:0]) ? ~q[8] : q[8]);
assign next_q[9] = reset ? 1'b0 : ((&q[8:0]) ? ~q[9] : q[9]);

always @(posedge clk) begin
    q <= next_q;
end

endmodule