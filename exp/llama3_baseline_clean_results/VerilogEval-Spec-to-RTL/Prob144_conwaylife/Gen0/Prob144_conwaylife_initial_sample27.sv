module TopModule(
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = 256'd0;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            reg alive_neighbors;
            alive_neighbors = 0;
            for (integer x = -1; x <= 1; x = x + 1) begin
                for (integer y = -1; y <= 1; y = y + 1) begin
                    if ((x == 0) && (y == 0)) begin
                        // Don't count the cell itself
                        continue;
                    end
                    reg neighbor_x, neighbor_y;
                    neighbor_x = (i + x) % 16;
                    if (neighbor_x < 0) begin
                        neighbor_x = neighbor_x + 16;
                    end
                    neighbor_y = (j + y) % 16;
                    if (neighbor_y < 0) begin
                        neighbor_y = neighbor_y + 16;
                    end
                    if (current_state[neighbor_x*16 + neighbor_y]) begin
                        alive_neighbors = alive_neighbors + 1;
                    end
                end
            end
            reg next_cell_state;
            if (alive_neighbors <= 1) begin
                next_cell_state = 1'd0;
            end else if (alive_neighbors == 2) begin
                next_cell_state = current_state[i*16 + j];
            end else if (alive_neighbors == 3) begin
                next_cell_state = 1'd1;
            end else begin
                next_cell_state = 1'd0;
            end
            next_state[i*16 + j] = next_cell_state;
        end
    end
end

assign q = current_state;

endmodule