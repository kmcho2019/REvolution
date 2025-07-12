module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        reg [31:0] next_q;
        next_q[0] = q[31] ^ q[21] ^ q[1] ^ q[0];
        next_q[1] = q[0];
        next_q[2] = q[1] ^ q[0];
        next_q[22] = q[21] ^ q[0];
        for (int i = 31; i > 22; i--) begin
            next_q[i] = q[i-1];
        end
        for (int i = 21; i > 2; i--) begin
            next_q[i] = q[i-1];
        end
        q <= next_q;
    end
end

endmodule