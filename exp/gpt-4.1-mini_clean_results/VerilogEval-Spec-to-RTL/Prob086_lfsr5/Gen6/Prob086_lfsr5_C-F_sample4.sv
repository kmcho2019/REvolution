module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

reg feedback;

// Compute feedback as q[0] on clock edge, combinationally valid next_q uses this feedback
wire [4:0] next_q;

assign next_q[0] = q[1];
assign next_q[1] = q[2];
assign next_q[2] = q[3] ^ feedback;  // tap at bit 3 (index 2)
assign next_q[3] = q[4];
assign next_q[4] = feedback;          // tap at bit 5 (index 4)

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
        feedback <= 1'b0; // feedback does not matter on reset, safe to set 0
    end else begin
        feedback <= q[0];
        q <= next_q;
    end
end

endmodule