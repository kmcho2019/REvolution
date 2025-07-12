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
    next_q = q;
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            reg [2:0] alive_neighbors;
            alive_neighbors = 0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if ((x == 0) && (y == 0)) begin
                        // skip the cell itself
                        continue;
                    end
                    reg [7:0] neighbor_x;
                    reg [7:0] neighbor_y;
                    neighbor_x = (i + x) % 16;
                    neighbor_y = (j + y) % 16;
                    reg [255:0] neighbor;
                    neighbor = q;
                    if (neighbor[(neighbor_y * 16) + neighbor_x]) begin
                        alive_neighbors = alive_neighbors + 1;
                    end
                end
            end
            reg [255:0] current_cell;
            current_cell = q;
            if ((alive_neighbors == 0) || (alive_neighbors == 1)) begin
                next_q[(i * 16) + j] = 0;
            end else if (alive_neighbors == 2) begin
                // do nothing, cell state doesn't change
            end else if (alive_neighbors == 3) begin
                next_q[(i * 16) + j] = 1;
            end else begin
                next_q[(i * 16) + j] = 0;
            end
        end
    end
end

endmodule