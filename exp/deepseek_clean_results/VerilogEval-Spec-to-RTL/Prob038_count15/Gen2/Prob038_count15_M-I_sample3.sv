module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire clk_enable = (q != 4'b1111);  // Clock gating when counter reaches 15
wire gated_clk = clk & clk_enable;

always @(posedge gated_clk or posedge reset) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        // Efficient increment using XOR (equivalent to q + 1)
        q[0] <= ~q[0];
        q[1] <= q[1] ^ (q[0] == 1);
        q[2] <= q[2] ^ (&q[1:0] == 1);
        q[3] <= q[3] ^ (&q[2:0] == 1);
    end
end

endmodule