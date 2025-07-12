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
        // Unrolled loop for calculating next states
        // To simplify, we'll consider boundary conditions and internal cells separately
        q_reg[0] <= 1'b0 ^ q_reg[1]; // Left boundary
        q_reg[511] <= q_reg[510] ^ 1'b0; // Right boundary
        
        // Internal cells
        for (int i = 1; i < 511; i++) begin
            q_reg[i] <= q_reg[i-1] ^ q_reg[i+1];
        end
    end
end

assign q = q_reg;

endmodule