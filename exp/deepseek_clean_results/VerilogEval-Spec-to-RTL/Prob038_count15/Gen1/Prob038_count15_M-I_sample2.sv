module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire counter_enable = (q != 4'b1111); // Enable until max count
wire gated_clk = clk & counter_enable;

always @(posedge gated_clk or posedge reset) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        // Carry-lookahead increment
        q[0] <= ~q[0];
        q[1] <= q[1] ^ q[0];
        q[2] <= q[2] ^ (&q[1:0]);
        q[3] <= q[3] ^ (&q[2:0]);
    end
end

endmodule