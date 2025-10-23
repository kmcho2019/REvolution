module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] state_reg;
reg [255:0] next_state_reg;

always @(posedge clk) begin
    if (load) begin
        state_reg <= data;
    end else begin
        state_reg <= next_state_reg;
    end
end

reg [7:0] neighbors [15:0][15:0];

always @(posedge clk) begin
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            reg [7:0] neighbor_count;
            neighbor_count = 0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) begin
                        // skip self
                        continue;
                    end
                    int idx_x = (i + x + 16) % 16;
                    int idx_y = (j + y + 16) % 16;
                    int idx = idx_x * 16 + idx_y;
                    neighbor_count += state_reg[idx];
                end
            end
            neighbors[i][j] <= neighbor_count;
        end
    end
end

always @(posedge clk) begin
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            reg next_state;
            reg [2:0] neighbor_count;
            neighbor_count = neighbors[i][j][2:0];
            if (neighbor_count <= 1) begin
                next_state = 0;
            end else if (neighbor_count == 2) begin
                next_state = state_reg[i * 16 + j];
            end else if (neighbor_count == 3) begin
                next_state = 1;
            end else begin
                next_state = 0;
            end
            next_state_reg[i * 16 + j] <= next_state;
        end
    end
end

assign q = state_reg;

endmodule