module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] q_next;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= q_next;
    end
end

always @(*) begin
    q_next = q;
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            reg alive_neighbors;
            alive_neighbors = 0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if ((x == 0) && (y == 0)) begin
                        continue;
                    end
                    int neighbor_x, neighbor_y;
                    neighbor_x = (i + x) % 16;
                    if (neighbor_x < 0) begin
                        neighbor_x += 16;
                    end
                    neighbor_y = (j + y) % 16;
                    if (neighbor_y < 0) begin
                        neighbor_y += 16;
                    end
                    alive_neighbors += q[neighbor_y + neighbor_x*16];
                end
            end
            if (alive_neighbors == 2) begin
                q_next[j + i*16] = q[j + i*16];
            end else if (alive_neighbors == 3) begin
                q_next[j + i*16] = 1'b1;
            end else begin
                q_next[j + i*16] = 1'b0;
            end
        end
    end
end

endmodule