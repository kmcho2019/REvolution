module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire [4:0] next_q;

assign next_q[4] = q[0];
assign next_q[3] = q[4];
assign next_q[2] = q[3] ^ q[0];
assign next_q[1] = q[2];
assign next_q[0] = q[1];

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        q <= next_q;
    end
end

endmodule