module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Initialize output
assign q = q_reg;

// Load data or advance state
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // Compute next state
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                // Left boundary is zero
                q_reg[i] <= q_reg[i + 1];
            end else if (i == 511) begin
                // Right boundary is zero
                q_reg[i] <= q_reg[i - 1];
            end else begin
                // Interior cells
                q_reg[i] <= q_reg[i - 1] ^ q_reg[i + 1];
            end
        end
    end
end

endmodule