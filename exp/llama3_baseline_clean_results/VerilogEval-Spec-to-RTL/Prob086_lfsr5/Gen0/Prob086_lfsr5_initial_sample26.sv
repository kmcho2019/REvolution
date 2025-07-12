module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q;

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b10000;
    end else begin
        q[4] <= q[3] ^ q[0];
        q[3] <= q[2] ^ q[0];
        q[2] <= q[1];
        q[1] <= q[0];
        q[0] <= q[4];
    end
end

endmodule