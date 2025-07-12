module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire [4:0] next_q;
wire tap_xor = q[3] ^ q[0];

assign next_q = reset ? 5'b00001 : {q[0], q[4], tap_xor, q[2], q[1]};

always @(posedge clk) begin
    q <= next_q;
end

endmodule