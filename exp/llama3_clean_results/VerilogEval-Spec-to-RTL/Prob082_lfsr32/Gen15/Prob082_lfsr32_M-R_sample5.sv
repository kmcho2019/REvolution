module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q[31] <= q[30] ^ q[21] ^ q[1] ^ q[0]; // Tap logic for MSB
        for (int i = 30; i > 0; i--) begin
            q[i] <= q[i-1]; // Shift right
        end
        q[0] <= q[31]; // Shift the MSB to the LSB position
    end
end

endmodule