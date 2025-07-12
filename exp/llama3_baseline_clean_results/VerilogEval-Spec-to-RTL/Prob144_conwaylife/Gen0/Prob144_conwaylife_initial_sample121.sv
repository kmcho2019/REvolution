module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

always @(*) begin
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            reg [2:0] neighbors;
            reg cell;

            cell = q[i*16 + j];

            // Count neighbors
            neighbors = 0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if ((x == 0) && (y == 0)) begin
                        // Skip the cell itself
                        continue;
                    end

                    reg neighbor_cell;
                    int neighbor_i = (i + x + 16) % 16;
                    int neighbor_j = (j + y + 16) % 16;

                    neighbor_cell = q[neighbor_i*16 + neighbor_j];
                    neighbors = neighbors + neighbor_cell;
                end
            end

            // Update cell state
            if ((neighbors < 2) || (neighbors > 3)) begin
                next_q[i*16 + j] = 0;
            end else if (neighbors == 2) begin
                next_q[i*16 + j] = cell;
            end else if (neighbors == 3) begin
                next_q[i*16 + j] = 1;
            end
        end
    end
end

endmodule