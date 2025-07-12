module AliveNeighborsCount(
    input [255:0] grid,
    output [255:0] alive_neighbors
);

reg [255:0] alive_neighbors_reg;

always @(*) begin
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            int index = i * 16 + j;
            reg [3:0] alive_neighbors_count;
            alive_neighbors_count = (
                grid[((i-1+16)%16)*16 + (j-1+16)%16] +
                grid[((i-1+16)%16)*16 + j] +
                grid[((i-1+16)%16)*16 + (j+1)%16] +
                grid[i*16 + (j-1+16)%16] +
                grid[i*16 + (j+1)%16] +
                grid[((i+1)%16)*16 + (j-1+16)%16] +
                grid[((i+1)%16)*16 + j] +
                grid[((i+1)%16)*16 + (j+1)%16]
            );
            alive_neighbors_reg[index] = alive_neighbors_count;
        end
    end
    alive_neighbors = alive_neighbors_reg;
end

endmodule

module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
wire [255:0] alive_neighbors;

AliveNeighborsCount alive_neighbors_count_module(
   .grid(grid),
   .alive_neighbors(alive_neighbors)
);

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (int i = 0; i < 256; i++) begin
            case (alive_neighbors[i])
                4'h0, 4'h1: q[i] <= 1'b0;
                4'h2: q[i] <= grid[i];
                4'h3: q[i] <= 1'b1;
                default: q[i] <= 1'b0;
            endcase
            grid[i] <= q[i];
        end
    end
end

endmodule