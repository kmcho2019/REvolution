module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];
wire [4:0] next_q;

assign next_q[0] = q[1];
assign next_q[1] = q[2];
assign next_q[2] = q[3] ^ feedback;
assign next_q[3] = q[4];
assign next_q[4] = feedback;

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= next_q;
end

endmodule