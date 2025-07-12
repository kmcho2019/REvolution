module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];
wire [4:0] next;

assign next[0] = q[1];
assign next[1] = q[2];
assign next[2] = q[3] ^ feedback;
assign next[3] = q[4];
assign next[4] = feedback;

always @(posedge clk) begin
    if (reset) 
        q <= 5'b00001;
    else
        q <= next;
end

endmodule