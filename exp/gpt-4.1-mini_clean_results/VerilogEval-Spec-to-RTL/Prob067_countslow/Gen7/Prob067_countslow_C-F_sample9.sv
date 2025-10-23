module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire [4:0] sum = q + slowena; // 5 bits to detect overflow > 9
wire next_wrap = (sum > 5'd9);
wire [3:0] next_q = next_wrap ? 4'd0 : sum[3:0];

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else if (slowena)
        q <= next_q;
    // else hold q
end

endmodule