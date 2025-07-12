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
    next_q = 256'b0;
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            int index = i * 16 + j;
            int alive_neighbors = 0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) continue;
                    int neighbor_i = (i + x + 16) % 16;
                    int neighbor_j = (j + y + 16) % 16;
                    int neighbor_index = neighbor_i * 16 + neighbor_j;
                    if (q[neighbor_index]) begin
                        alive_neighbors++;
                    end
                end
            end
            if (q[index] && (alive_neighbors == 2 || alive_neighbors == 3)) begin
                next_q[index] = 1'b1;
            end else if (!q[index] && alive_neighbors == 3) begin
                next_q[index] = 1'b1;
            end else begin
                next_q[index] = 1'b0;
            end
        end
    end
end

endmodule