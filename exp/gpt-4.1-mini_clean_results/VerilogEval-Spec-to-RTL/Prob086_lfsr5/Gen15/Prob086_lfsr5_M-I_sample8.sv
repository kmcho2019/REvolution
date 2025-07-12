module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];
wire [4:0] next_q;

assign next_q = {
    feedback,
    q[4],
    q[3] ^ feedback,
    q[2],
    q[1]
};

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= next_q;
end

endmodule