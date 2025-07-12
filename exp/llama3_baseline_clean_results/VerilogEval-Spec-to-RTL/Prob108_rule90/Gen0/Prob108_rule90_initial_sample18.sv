module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                // Left boundary: q[-1] = 0
                q_reg[i] <= q_reg[i + 1];
            end else if (i == 511) begin
                // Right boundary: q[512] = 0
                q_reg[i] <= q_reg[i - 1];
            end else begin
                // Internal cells: XOR of left and right neighbors
                q_reg[i] <= q_reg[i - 1] ^ q_reg[i + 1];
            end
        end
    end
end

assign q = q_reg;

endmodule