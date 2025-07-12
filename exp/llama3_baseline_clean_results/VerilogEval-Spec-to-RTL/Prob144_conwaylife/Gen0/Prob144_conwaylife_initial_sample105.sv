module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        reg [255:0] next_state;
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [2:0] alive_neighbors;
                alive_neighbors = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if ((x == 0) && (y == 0)) continue;
                        reg [7:0] neighbor_x, neighbor_y;
                        neighbor_x = (i + x) % 16;
                        neighbor_y = (j + y) % 16;
                        if (q_reg[neighbor_x * 16 + neighbor_y]) begin
                            alive_neighbors <= alive_neighbors + 1;
                        end
                    end
                end
                reg cell_state;
                cell_state = q_reg[i * 16 + j];
                if (alive_neighbors == 2) begin
                    next_state[i * 16 + j] <= cell_state;
                end else if (alive_neighbors == 3) begin
                    next_state[i * 16 + j] <= 1;
                end else begin
                    next_state[i * 16 + j] <= 0;
                end
            end
        end
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule