module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) q <= 1;
    else q <= {q[0], q[4], q[3] ^ q[0], q[2], q[1]};
end

endmodule