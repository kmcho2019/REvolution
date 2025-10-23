module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q[31] <= q[22] ^ q[0];
        for (int i = 30; i >= 23; i--) begin
            q[i] <= q[i-1];
        end
        q[22:2] <= {q[21:1], q[1]};
        q[1] <= q[0] ^ q[2];
        q[0] <= q[1] ^ q[2];
    end
end

endmodule