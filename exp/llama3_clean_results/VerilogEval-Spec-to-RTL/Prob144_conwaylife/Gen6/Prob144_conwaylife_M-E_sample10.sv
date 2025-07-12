module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// State machine for a single cell
module CellStateMachine(
    input clk,
    input load,
    input data,
    input [7:0] neighbors,
    output reg q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case (neighbors)
            0, 1: q <= 1'b0;
            2: q <= q;
            3: q <= 1'b1;
            default: q <= 1'b0;
        endcase
    end
end

endmodule

// Module to calculate neighbors for a cell in a toroidal grid
module NeighborCalculator(
    input [255:0] grid,
    input [3:0] row,
    input [3:0] col,
    output reg [7:0] neighbors
);

reg [7:0] n;

always @(*) begin
    n = 0;
    for (int i = -1; i <= 1; i++) begin
        for (int j = -1; j <= 1; j++) begin
            if (i == 0 && j == 0) continue;
            int r = (row + i + 16) % 16;
            int c = (col + j + 16) % 16;
            n += grid[r*16 + c];
        end
    end
    neighbors <= n;
end

endmodule

// Instantiation of cell state machines and neighbor calculators
genvar i;
generate
    for (i = 0; i < 256; i++) begin
        NeighborCalculator nc(
           .grid(q),
           .row(i/16),
           .col(i%16),
           .neighbors(neighbors[i])
        );
        CellStateMachine cs(
           .clk(clk),
           .load(load),
           .data(data[i]),
           .neighbors(neighbors[i]),
           .q(q[i])
        );
    end
endgenerate

reg [7:0] neighbors[255:0];

endmodule