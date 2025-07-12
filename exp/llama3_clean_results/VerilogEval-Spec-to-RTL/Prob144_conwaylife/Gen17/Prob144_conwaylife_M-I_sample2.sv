module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;

// Function to calculate the row index of a neighboring cell
function reg [3:0] get_row_idx;
    input [7:0] row;
    input [3:0] offset;
    reg [3:0] row_idx;
    row_idx = (row + offset) % 16;
    if (row_idx < 0) row_idx += 16;
    get_row_idx = row_idx;
endfunction

// Function to calculate the column index of a neighboring cell
function reg [3:0] get_col_idx;
    input [7:0] col;
    input [3:0] offset;
    reg [3:0] col_idx;
    col_idx = (col + offset) % 16;
    if (col_idx < 0) col_idx += 16;
    get_col_idx = col_idx;
endfunction

// Load initial state
always @(posedge clk) begin
    if (load) begin
        grid = data;
    end else begin
        reg [255:0] next_grid;
        for (int i = 0; i < 256; i++) begin
            reg [7:0] row = i / 16;
            reg [7:0] col = i % 16;
            reg [3:0] count = 0;
            for (int offset_row = -1; offset_row <= 1; offset_row++) begin
                for (int offset_col = -1; offset_col <= 1; offset_col++) begin
                    if (offset_row == 0 && offset_col == 0) continue;
                    reg [3:0] row_idx = get_row_idx(row, offset_row);
                    reg [3:0] col_idx = get_col_idx(col, offset_col);
                    count += grid[row_idx * 16 + col_idx];
                end
            end
            if (count <= 1 || count >= 4) begin
                next_grid[i] = 1'b0;
            end else if (count == 3) begin
                next_grid[i] = 1'b1;
            end else begin
                next_grid[i] = grid[i];
            end
        end
        grid = next_grid;
    end
end

// Output final state
always @(posedge clk) begin
    q = grid;
end

endmodule