module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;
reg [255:0] next_state;

assign q = q_reg;

always @(*) begin
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            int index = i * 16 + j;
            int alive_neighbors = 0;

            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) continue;

                    int neighbor_x = (i + x + 16) % 16;
                    int neighbor_y = (j + y + 16) % 16;
                    int neighbor_index = neighbor_x * 16 + neighbor_y;

                    if (q_reg[neighbor_index]) begin
                        alive_neighbors++;
                    end
                end
            end

            if (alive_neighbors <= 1 || alive_neighbors >= 4) begin
                next_state[index] = 0;
            end else if (alive_neighbors == 3) begin
                next_state[index] = 1;
            end else begin
                next_state[index] = q_reg[index];
            end
        end
    end
end

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

endmodule