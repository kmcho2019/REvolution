module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

integer i, j;
reg [3:0] neighbors;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (i = 0; i < 256; i = i + 1) begin
            j = i / 16;
            neighbors = 0;
            // Calculate neighbors
            for (int k = -1; k <= 1; k = k + 1) begin
                for (int l = -1; l <= 1; l = l + 1) begin
                    if (k == 0 && l == 0) begin
                        // Don't count the cell itself as a neighbor
                        continue;
                    end
                    neighbors = neighbors + q_reg[((((j + k) % 16) * 16) + ((i % 16) + l) % 16)];
                end
            end
            // Update cell state based on neighbors
            if (neighbors <= 1 || neighbors >= 4) begin
                q_reg[i] <= 0;
            end else if (neighbors == 3) begin
                q_reg[i] <= 1;
            end
        end
    end
end

assign q = q_reg;

endmodule