module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];
wire [4:0] next_q;

assign next_q[0] = q[1];
assign next_q[1] = q[2];
assign next_q[2] = q[3] ^ feedback; // tap at bit 3 (q[2])
assign next_q[3] = q[4];
assign next_q[4] = feedback;        // tap at bit 5 (q[4])

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= next_q;
    end
end

endmodule