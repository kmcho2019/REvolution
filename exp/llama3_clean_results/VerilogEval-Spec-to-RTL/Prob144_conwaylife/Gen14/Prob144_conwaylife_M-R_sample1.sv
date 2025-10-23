module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

// Calculate neighbor count for each cell
wire [255:0] neighbor_count;
genvar i;
generate
    for (i = 0; i < 256; i++) begin
        wire [3:0] count;
        assign count = 
            (grid[((i / 16) + 15) % 16 * 16 + ((i % 16) + 1) % 16]) +
            (grid[((i / 16) + 15) % 16 * 16 + ((i % 16) - 1 + 16) % 16]) +
            (grid[((i / 16) + 1) % 16 * 16 + ((i % 16) + 1) % 16]) +
            (grid[((i / 16) + 1) % 16 * 16 + ((i % 16) - 1 + 16) % 16]) +
            (grid[((i / 16) + 1) % 16 * 16 + (i % 16)]) +
            (grid[((i / 16) - 1 + 16) % 16 * 16 + ((i % 16) + 1) % 16]) +
            (grid[((i / 16) - 1 + 16) % 16 * 16 + ((i % 16) - 1 + 16) % 16]) +
            (grid[((i / 16) - 1 + 16) % 16 * 16 + (i % 16)]);
        assign neighbor_count[i] = count;
    end
endgenerate

// Game logic to update the grid
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (int i = 0; i < 256; i++) begin
            if (neighbor_count[i] <= 1 || neighbor_count[i] >= 4) begin
                next_grid[i] <= 1'b0;
            end else if (neighbor_count[i] == 3) begin
                next_grid[i] <= 1'b1;
            end else begin
                next_grid[i] <= grid[i];
            end
        end
        grid <= next_grid;
    end
    q <= grid;
end

endmodule