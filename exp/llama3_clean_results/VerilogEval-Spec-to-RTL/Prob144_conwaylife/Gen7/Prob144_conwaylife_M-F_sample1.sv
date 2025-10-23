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
        for (reg [7:0] row = 0; row < 16; row = row + 1) begin
            for (reg [3:0] col = 0; col < 16; col = col + 1) begin
                reg [7:0] index = (row * 16) + col;
                reg [2:0] alive_neighbors;
                alive_neighbors = 0;

                // Unroll the inner loop to calculate alive neighbors
                // Calculate neighbors for current cell
                for (reg [1:0] x = 0; x < 3; x = x + 1) begin
                    for (reg [1:0] y = 0; y < 3; y = y + 1) begin
                        if (x!= 1 || y!= 1) begin
                            reg [3:0] x_index = (row + x - 1 + 16) % 16;
                            reg [3:0] y_index = (col + y - 1 + 16) % 16;
                            reg [7:0] neighbor_index = (x_index * 16) + y_index;
                            if (q[neighbor_index]) begin
                                alive_neighbors = alive_neighbors + 1;
                            end
                        end
                    end
                end

                // Update next state based on alive neighbors
                if (alive_neighbors == 3 || (alive_neighbors == 2 && q[index])) begin
                    next_q[index] = 1;
                end else begin
                    next_q[index] = 0;
                end
            end
        end
        q <= next_q;
    end
end

endmodule