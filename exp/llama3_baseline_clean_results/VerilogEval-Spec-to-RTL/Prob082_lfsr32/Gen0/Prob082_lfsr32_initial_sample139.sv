module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q[31] <= q[0] ^ q[21] ^ q[1] ^ q[0];
        for (int i = 30; i > 0; i--) begin
            q[i] <= q[i-1];
        end
        q[0] <= q[31];
    end
end

endmodule