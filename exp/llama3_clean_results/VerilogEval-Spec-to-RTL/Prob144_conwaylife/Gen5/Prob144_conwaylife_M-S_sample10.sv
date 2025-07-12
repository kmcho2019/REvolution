module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;

// Function to count alive neighbours
function [3:0] count_neighbours;
    input [7:0] row;
    input [7:0] col;
    reg [3:0] count;
    begin
        count = 0;
        for (int i = -1; i <= 1; i++) begin
            for (int j = -1; j <= 1; j++) begin
                if ((i == 0) && (j == 0)) begin
                    continue;
                end
                reg [7:0] new_row;
                reg [7:0] new_col;
                new_row = (row + i + 16) % 16;
                new_col = (col + j + 16) % 16;
                reg index;
                index = (new_row * 16) + new_col;
                if (grid[index]) begin
                    count = count + 1;
                end
            end
        end
        count_neighbours = count;
    end
endfunction

// Update grid state
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg index;
                index = (i * 16) + j;
                reg [3:0] neighbours;
                neighbours = count_neighbours(i, j);
                case (neighbours)
                    4'd0, 4'd1: grid[index] <= 1'b0;
                    4'd2: grid[index] <= grid[index];
                    4'd3: grid[index] <= 1'b1;
                    default: grid[index] <= 1'b0;
                endcase
            end
        end
    end
    q <= grid;
end

endmodule