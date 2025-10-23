module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
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

always @(posedge clk) begin
    for (int row = 0; row < 16; row = row + 1) begin
        for (int col = 0; col < 16; col = col + 1) begin
            int alive_neighbors = 0;
            for (int x = -1; x <= 1; x = x + 1) begin
                for (int y = -1; y <= 1; y = y + 1) begin
                    if (x != 0 || y != 0) begin
                        int neighbor_row = (row + x + 16) % 16;
                        int neighbor_col = (col + y + 16) % 16;
                        int neighbor_index = (neighbor_row * 16) + neighbor_col;
                        if (current_state[neighbor_index]) begin
                            alive_neighbors = alive_neighbors + 1;
                        end
                    end
                end
            end
            int cell_index = (row * 16) + col;
            if ((alive_neighbors == 3) || (alive_neighbors == 2 && current_state[cell_index])) begin
                next_state[cell_index] <= 1'b1;
            end else begin
                next_state[cell_index] <= 1'b0;
            end
        end
    end
end

assign q = current_state;

endmodule