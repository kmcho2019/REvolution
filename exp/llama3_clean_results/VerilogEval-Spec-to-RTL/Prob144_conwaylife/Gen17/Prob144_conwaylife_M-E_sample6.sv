module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

parameter SIZE = 16;

reg [SIZE-1:0][SIZE-1:0] grid;
reg [SIZE-1:0][SIZE-1:0] next_grid;

// Cell module
module Cell(
    input [8:0] neighbors,
    input current,
    output next
);
    reg [2:0] count;
    always @* begin
        count = neighbors;
        if (count == 3 || (count == 2 && current == 1'b1)) begin
            next = 1'b1;
        end else begin
            next = 1'b0;
        end
    end
endmodule

// Neighbor calculation module
module Neighbors(
    input [SIZE-1:0][SIZE-1:0] grid,
    input [4:0] x,
    input [4:0] y,
    output [8:0] neighbors
);
    reg [8:0] n;
    always @* begin
        n = 9'b0;
        for (int i = -1; i <= 1; i++) begin
            for (int j = -1; j <= 1; j++) begin
                if (i == 0 && j == 0) continue;
                n |= grid[(x + i + SIZE) % SIZE][(y + j + SIZE) % SIZE];
            end
        end
        neighbors = n;
    end
endmodule

// Grid assembly module
module GridAssembly(
    input [SIZE-1:0][SIZE-1:0] next_grid,
    output [255:0] q
);
    always @* begin
        for (int i = 0; i < SIZE; i++) begin
            for (int j = 0; j < SIZE; j++) begin
                q[i*SIZE + j] = next_grid[i][j];
            end
        end
    end
endmodule

// Sequential logic to handle loading and clocking
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        grid <= next_grid;
    end
end

// Combinational logic to compute the next grid state
for (genvar i = 0; i < SIZE; i++) begin
    for (genvar j = 0; j < SIZE; j++) begin
        wire [8:0] neighbors;
        Neighbors n(.grid(grid),.x(i),.y(j),.neighbors(neighbors));
        Cell c(.neighbors(neighbors),.current(grid[i][j]),.next(next_grid[i][j]));
    end
end

// Assign output q directly from grid
GridAssembly ga(.next_grid(next_grid),.q(q));

endmodule