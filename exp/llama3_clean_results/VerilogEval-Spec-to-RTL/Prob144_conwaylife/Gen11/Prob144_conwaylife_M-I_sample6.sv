module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [15:0][15:0] current_state;
reg [15:0][15:0] next_state;
reg [7:0] alive_neighbors [15:0][15:0];

// Load current state
always @(posedge clk) begin
    if (load) begin
        for (int row = 0; row < 16; row = row + 1) begin
            for (int col = 0; col < 16; col = col + 1) begin
                int index = (row * 16) + col;
                current_state[row][col] <= data[index];
            end
        end
    end else begin
        current_state <= next_state;
    end
end

// Pipeline stage 1: Calculate alive neighbors
always @(posedge clk) begin
    for (int row = 0; row < 16; row = row + 1) begin
        for (int col = 0; col < 16; col = col + 1) begin
            alive_neighbors[row][col] = 0;
            for (int x = -1; x <= 1; x = x + 1) begin
                for (int y = -1; y <= 1; y = y + 1) begin
                    if (x!= 0 || y!= 0) begin
                        int x_index = (row + x + 16) % 16;
                        int y_index = (col + y + 16) % 16;
                        if (current_state[x_index][y_index]) begin
                            alive_neighbors[row][col] = alive_neighbors[row][col] + 1;
                        end
                    end
                end
            end
        end
    end
end

// Pipeline stage 2: Update next state
always @(posedge clk) begin
    for (int row = 0; row < 16; row = row + 1) begin
        for (int col = 0; col < 16; col = col + 1) begin
            if (alive_neighbors[row][col] == 3 || (alive_neighbors[row][col] == 2 && current_state[row][col])) begin
                next_state[row][col] <= 1;
            end else begin
                next_state[row][col] <= 0;
            end
        end
    end
end

// Output updated state
always @(*) begin
    for (int row = 0; row < 16; row = row + 1) begin
        for (int col = 0; col < 16; col = col + 1) begin
            int index = (row * 16) + col;
            q[index] = current_state[row][col];
        end
    end
end

endmodule