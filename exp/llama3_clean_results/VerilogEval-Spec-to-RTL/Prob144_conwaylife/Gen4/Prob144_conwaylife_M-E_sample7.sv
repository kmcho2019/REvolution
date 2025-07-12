module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [15:0] new_grid_row[15:0];

// Pipeline stage 1: Load and replicate
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end
end

// Pipeline stage 2: Count alive neighbours
wire [3:0] alive_neighbours[15:0][15:0];
genvar i, j;
generate
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            reg [3:0] count;
            reg [3:0] new_row, new_col;
            assign new_row = (i + 1 < 16)? i + 1 : 0;
            assign new_col = (j + 1 < 16)? j + 1 : 0;
            assign alive_neighbours[i][j] = (
                (grid[(i - 1 < 0? 15 : i - 1) * 16 + (j - 1 < 0? 15 : j - 1)]) +
                (grid[(i - 1 < 0? 15 : i - 1) * 16 + j]) +
                (grid[(i - 1 < 0? 15 : i - 1) * 16 + (j + 1 > 15? 0 : j + 1)]) +
                (grid[i * 16 + (j - 1 < 0? 15 : j - 1)]) +
                (grid[i * 16 + (j + 1 > 15? 0 : j + 1)]) +
                (grid[(i + 1 > 15? 0 : i + 1) * 16 + (j - 1 < 0? 15 : j - 1)]) +
                (grid[(i + 1 > 15? 0 : i + 1) * 16 + j]) +
                (grid[(i + 1 > 15? 0 : i + 1) * 16 + (j + 1 > 15? 0 : j + 1)])
            );
        end
    end
endgenerate

// Pipeline stage 3: Update grid
always @(posedge clk) begin
    if (!load) begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                case (alive_neighbours[i][j])
                    0, 1: new_grid_row[i][j] <= 0;
                    2: new_grid_row[i][j] <= grid[i * 16 + j];
                    3: new_grid_row[i][j] <= 1;
                    default: new_grid_row[i][j] <= 0;
                endcase
            end
        end
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int index = i * 16 + j;
                q[index] <= new_grid_row[i][j];
                grid[index] <= new_grid_row[i][j];
            end
        end
    end
end

endmodule