module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

integer row, col;

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (row = 0; row < 16; row++) begin
            for (col = 0; col < 16; col++) begin
                integer index = row * 16 + col;
                integer count = 0;
                for (integer i = -1; i <= 1; i++) begin
                    for (integer j = -1; j <= 1; j++) begin
                        if ((i == 0) && (j == 0)) begin
                            continue;
                        end
                        integer new_row = (row + i + 16) % 16;
                        integer new_col = (col + j + 16) % 16;
                        if (grid[new_row * 16 + new_col]) begin
                            count = count + 1;
                        end
                    end
                end
                if (count == 0 || count == 1) begin
                    next_grid[index] = 1'b0;
                end else if (count == 2) begin
                    next_grid[index] = grid[index];
                end else if (count == 3) begin
                    next_grid[index] = 1'b1;
                end else begin
                    next_grid[index] = 1'b0;
                end
            end
        end
        grid <= next_grid;
    end
    q <= grid;
end

endmodule