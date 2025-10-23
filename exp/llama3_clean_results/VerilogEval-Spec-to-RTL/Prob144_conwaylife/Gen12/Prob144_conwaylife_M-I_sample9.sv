module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

// Load current state
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

// Pipeline stage 1: Calculate alive neighbors
always @(posedge clk) begin
    next_state <= 0;
    for (int row = 0; row < 16; row = row + 1) begin
        for (int col = 0; col < 16; col = col + 1) begin
            int index = (row * 16) + col;
            int alive_neighbors = 0;
            for (int x = -1; x <= 1; x = x + 1) begin
                for (int y = -1; y <= 1; y = y + 1) begin
                    if (x!= 0 || y!= 0) begin
                        int x_index = (row + x + 16) % 16;
                        int y_index = (col + y + 16) % 16;
                        int neighbor_index = (x_index * 16) + y_index;
                        if (current_state[neighbor_index]) begin
                            alive_neighbors = alive_neighbors + 1;
                        end
                    end
                end
            end
            if (alive_neighbors == 3 || (alive_neighbors == 2 && current_state[index])) begin
                next_state[index] <= 1;
            end
        end
    end
end

// Output updated state
always @(posedge clk) begin
    q <= current_state;
end

endmodule