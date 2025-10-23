module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                q_reg[i] <= q_reg[i+1]; // left boundary is 0, so just take the right neighbor
            end else if (i == 511) begin
                q_reg[i] <= q_reg[i-1]; // right boundary is 0, so just take the left neighbor
            end else begin
                q_reg[i] <= q_reg[i-1] ^ q_reg[i+1]; // XOR of left and right neighbors
            end
        end
    end
end

assign q = q_reg;

endmodule