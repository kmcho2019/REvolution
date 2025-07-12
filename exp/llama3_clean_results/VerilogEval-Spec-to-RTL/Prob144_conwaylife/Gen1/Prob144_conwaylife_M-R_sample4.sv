module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

// Calculate the next state
always @(*) begin
    if (load) begin
        next_q = data;
    end else begin
        next_q = q;
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [2:0] alive_neighbors;
                alive_neighbors = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue;
                        int neighbor_x, neighbor_y;
                        neighbor_x = (i + x + 16) % 16;
                        neighbor_y = (j + y + 16) % 16;
                        int index = neighbor_x * 16 + neighbor_y;
                        alive_neighbors += q[index];
                    end
                end
                int index = i * 16 + j;
                if (alive_neighbors < 2 || alive_neighbors > 3) begin
                    next_q[index] = 0;
                end else if (alive_neighbors == 3) begin
                    next_q[index] = 1;
                end
            end
        end
    end
end

// Update the current state
always @(posedge clk) begin
    q <= next_q;
end

endmodule