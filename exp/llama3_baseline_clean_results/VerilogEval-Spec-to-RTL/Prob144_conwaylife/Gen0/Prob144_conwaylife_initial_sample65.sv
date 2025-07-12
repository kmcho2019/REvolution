module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;
reg [255:0] q_next;

integer i, j, neighbor_count;
reg [255:0] temp_q;

assign q = q_reg;

always @(*) begin
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            neighbor_count = 0;
            // Count alive neighbors
            for (integer x = -1; x <= 1; x++) begin
                for (integer y = -1; y <= 1; y++) begin
                    integer neighbor_i, neighbor_j;
                    if (x == 0 && y == 0) begin
                        // Skip the cell itself
                        continue;
                    end
                    neighbor_i = (i + x + 16) % 16;
                    neighbor_j = (j + y + 16) % 16;
                    if (q_reg[neighbor_i * 16 + neighbor_j]) begin
                        neighbor_count++;
                    end
                end
            end
            // Apply rules
            if (neighbor_count <= 1 || neighbor_count >= 4) begin
                temp_q[i * 16 + j] = 0;
            end else if (neighbor_count == 2) begin
                temp_q[i * 16 + j] = q_reg[i * 16 + j];
            end else if (neighbor_count == 3) begin
                temp_q[i * 16 + j] = 1;
            end
        end
    end
    q_next = temp_q;
end

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= q_next;
    end
end

endmodule