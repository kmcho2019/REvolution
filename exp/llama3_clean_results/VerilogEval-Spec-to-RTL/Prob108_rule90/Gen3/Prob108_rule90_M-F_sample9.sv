module TopModule (
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
        // Calculate the next state of each cell directly from its neighbors
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            // Boundary conditions
            if (i == 0) begin
                left = 0;
                center = q_reg[i];
                if (i == 511) begin
                    right = 0;
                end else begin
                    right = q_reg[i + 1];
                end
            end else if (i == 511) begin
                left = q_reg[i - 1];
                center = q_reg[i];
                right = 0;
            end else begin                // General case
                left = q_reg[i - 1];
                center = q_reg[i];
                right = q_reg[i + 1];
            end
            // Apply Rule 90 logic
            q_reg[i] <= left ^ right; // No need to explicitly include center in XOR operation
        end
    end
end

assign q = q_reg;

endmodule