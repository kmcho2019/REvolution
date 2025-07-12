module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) q <= 32'h1;
    else q <= {q[0], q[31:1]} ^ ({32{q[0]}} & 32'h80000003);
end

endmodule