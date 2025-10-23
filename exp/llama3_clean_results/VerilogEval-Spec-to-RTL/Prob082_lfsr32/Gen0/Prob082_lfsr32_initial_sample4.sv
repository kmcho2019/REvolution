module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q[31] <= q[0] ^ q[21] ^ q[1] ^ q[0];
        q[30:22] <= q[29:21];
        q[21:2] <= q[20:1];
        q[1:0] <= q[0];
        q[20] <= q[19];
        q[19:2] <= q[18:1];
    end
end

endmodule