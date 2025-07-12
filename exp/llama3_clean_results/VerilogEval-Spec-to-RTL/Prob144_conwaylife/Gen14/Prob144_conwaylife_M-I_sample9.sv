module Cell(
    input clk,
    input [7:0] neighbors,
    input load,
    input data,
    output reg q
);

reg next_q;

always @(*) begin
    case (neighbors)
        8'b00000000, 8'b00000001: next_q = 0;
        8'b00000010: next_q = q;
        8'b00000100: next_q = 1;
        default: next_q = 0;
    endcase
end

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule

module Neighbor(
    input [255:0] grid,
    input [4:0] row,
    input [4:0] col,
    output reg [7:0] neighbors
);

always @(*) begin
    neighbors[0] = grid[((((col - 1) % 16) + 16) % 16) + (((row - 1) % 16) + 16) % 16 * 16];
    neighbors[1] = grid[((col + 16) % 16) + (((row - 1) % 16) + 16) % 16 * 16];
    neighbors[2] = grid[((((col + 1) % 16) + 16) % 16) + (((row - 1) % 16) + 16) % 16 * 16];
    neighbors[3] = grid[((((col - 1) % 16) + 16) % 16) + ((row + 16) % 16) * 16];
    neighbors[4] = grid[((col + 16) % 16) + ((row + 16) % 16) * 16];
    neighbors[5] = grid[((((col + 1) % 16) + 16) % 16) + ((row + 16) % 16) * 16];
    neighbors[6] = grid[((((col - 1) % 16) + 16) % 16) + (((row + 1) % 16) + 16) % 16 * 16];
    neighbors[7] = grid[((col + 16) % 16) + (((row + 1) % 16) + 16) % 16 * 16];
end

endmodule

module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

genvar i;
reg [255:0] grid;
reg [255:0] next_grid;

generate
    for (i = 0; i < 256; i++) begin
        reg [7:0] neighbors;
        Neighbor neighbor(
            .grid(grid),
            .row(i / 16),
            .col(i % 16),
            .neighbors(neighbors)
        );

        Cell cell(
            .clk(clk),
            .neighbors(neighbors),
            .load(load),
            .data(data[i]),
            .q(q[i])
        );
    end
endgenerate

always @(posedge clk) begin
    if (!load) begin
        grid <= q;
    end
end

endmodule