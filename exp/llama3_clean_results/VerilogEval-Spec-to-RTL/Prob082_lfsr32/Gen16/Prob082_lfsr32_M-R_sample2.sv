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
        next_q[0] = q[31] ^ q[21] ^ q[1] ^ q[0]; // Tap logic for LSB
        for (int i = 1; i < 32; i++) begin
            next_q[i] = q[i-1]; // Shift right
        end
        q <= next_q;
    end
end

endmodule