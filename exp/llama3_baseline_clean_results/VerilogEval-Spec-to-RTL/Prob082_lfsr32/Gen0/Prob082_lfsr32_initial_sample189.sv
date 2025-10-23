module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q[31] <= q[30];
        q[30] <= q[29];
        q[29:22] <= q[28:21];
        q[21] <= q[20];
        q[20:1] <= q[19:0];
        q[0] <= q[0] ^ q[22] ^ q[1] ^ q[2];
    end
end

endmodule