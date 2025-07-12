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
        next_q = q;
        for (int i = 0; i < 256; i = i + 1) begin
            reg [2:0] alive_neighbors = 0;
            for (int x = -1; x <= 1; x = x + 1) begin
                for (int y = -1; y <= 1; y = y + 1) begin
                    if (x == 0 && y == 0) begin
                        continue;
                    end
                    int neighbor_index = ((i / 16 + x + 16) % 16) * 16 + (i % 16 + y + 16) % 16;
                    alive_neighbors = alive_neighbors + q[neighbor_index];
                end
            end
            if (alive_neighbors < 2 || alive_neighbors > 3) begin
                next_q[i] = 0;
            end else if (alive_neighbors == 3) begin
                next_q[i] = 1;
            end else begin
                next_q[i] = q[i];
            end
        end
        q <= next_q;
    end
end

endmodule