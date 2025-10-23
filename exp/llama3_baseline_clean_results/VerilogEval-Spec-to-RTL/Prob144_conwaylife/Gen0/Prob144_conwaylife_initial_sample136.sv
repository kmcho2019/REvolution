module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = current_state;
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            int alive_neighbours = 0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) continue;
                    int neighbour_x = (i + x + 16) % 16;
                    int neighbour_y = (j + y + 16) % 16;
                    int neighbour_index = neighbour_x * 16 + neighbour_y;
                    alive_neighbours += current_state[neighbour_index];
                end
            end
            int cell_index = i * 16 + j;
            if (alive_neighbours <= 1 || alive_neighbours >= 4) begin
                next_state[cell_index] = 0;
            end else if (alive_neighbours == 3) begin
                next_state[cell_index] = 1;
            end
        end
    end
end

assign q = current_state;

endmodule