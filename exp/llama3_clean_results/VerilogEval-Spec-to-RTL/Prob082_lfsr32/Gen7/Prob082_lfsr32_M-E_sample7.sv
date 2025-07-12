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
        next_q[0] = q[31] ^ q[22] ^ q[2] ^ q[1];
        for (int i = 1; i < 32; i++) begin
            if (i == 31 || i == 22 || i == 2 || i == 1) begin
                next_q[i] = q[i-1] ^ q[0];
            end else begin
                next_q[i] = q[i-1];
            end
        end
        q <= next_q;
    end
end

endmodule