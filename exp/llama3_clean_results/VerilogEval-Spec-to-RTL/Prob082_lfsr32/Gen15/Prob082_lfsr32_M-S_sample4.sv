module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1; // Reset to 1
    end else begin
        q[0] <= q[31] ^ q[21] ^ q[1] ^ q[0];
        for (int i = 31; i > 0; i--) begin
            q[i] <= q[i-1];
        end
    end
end

endmodule