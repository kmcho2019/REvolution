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
        // Unroll the loop for the first and last cells
        q_reg[0] <= q_reg[1];
        q_reg[511] <= q_reg[510];
        
        // Unroll the loop for the remaining cells
        for (int i = 1; i < 511; i++) begin
            q_reg[i] <= q_reg[i - 1] ^ q_reg[i + 1];
        end
    end
end

assign q = q_reg;

endmodule