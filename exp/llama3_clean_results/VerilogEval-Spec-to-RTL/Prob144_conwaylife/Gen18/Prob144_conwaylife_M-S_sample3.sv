module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;

// Load initial state and update game state
always @(posedge clk) begin
    if (load) begin
        grid = data;
    end else begin
        for (int i = 0; i < 256; i++) begin
            reg [3:0] count = 0;
            for (int offset_row = -1; offset_row <= 1; offset_row++) begin
                for (int offset_col = -1; offset_col <= 1; offset_col++) begin
                    if (offset_row == 0 && offset_col == 0) continue;
                    reg [3:0] row = i / 16;
                    reg [3:0] col = i % 16;
                    reg [3:0] row_idx = (row + offset_row + 16) % 16;
                    reg [3:0] col_idx = (col + offset_col + 16) % 16;
                    count += grid[row_idx * 16 + col_idx];
                end
            end
            if (count <= 1 || count >= 4) begin
                grid[i] = 1'b0;
            end else if (count == 3) begin
                grid[i] = 1'b1;
            end else begin
                // No change
            end
        end
    end
end

// Output final state
always @(posedge clk) begin
    q = grid;
end

endmodule