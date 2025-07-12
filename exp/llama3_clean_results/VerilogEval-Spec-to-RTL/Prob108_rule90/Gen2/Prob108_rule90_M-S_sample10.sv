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
        // Correctly apply Rule 90 for the first cell
        q_reg[0] <= 1'b0 ^ q_reg[1];
        
        // Apply Rule 90 for all other cells
        for (int i = 1; i < 511; i++) begin
            q_reg[i] <= q_reg[i-1] ^ q_reg[i+1];
        end
        
        // Correctly apply Rule 90 for the last cell
        q_reg[511] <= q_reg[510] ^ 1'b0;
    end
end

assign q = q_reg;

endmodule