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

module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

genvar i;
generate
    for (i = 0; i < 256; i++) begin
        wire [7:0] neighbors;
        assign neighbors[0] = grid[((i % 16) - 1 + 16) % 16 + ((i / 16) - 1 + 16) % 16 * 16];
        assign neighbors[1] = grid[((i % 16) + 16) % 16 + ((i / 16) - 1 + 16) % 16 * 16];
        assign neighbors[2] = grid[((i % 16) + 1 + 16) % 16 + ((i / 16) - 1 + 16) % 16 * 16];
        assign neighbors[3] = grid[((i % 16) - 1 + 16) % 16 + ((i / 16) + 16) % 16 * 16];
        assign neighbors[4] = grid[((i % 16) + 16) % 16 + ((i / 16) + 16) % 16 * 16];
        assign neighbors[5] = grid[((i % 16) + 1 + 16) % 16 + ((i / 16) + 16) % 16 * 16];
        assign neighbors[6] = grid[((i % 16) - 1 + 16) % 16 + ((i / 16) + 1 + 16) % 16 * 16];
        assign neighbors[7] = grid[((i % 16) + 16) % 16 + ((i / 16) + 1 + 16) % 16 * 16];

        Cell cell(
           .clk(clk),
           .neighbors(neighbors),
           .load(load),
           .data(data[i]),
           .q(q[i])
        );
    end
endgenerate

endmodule