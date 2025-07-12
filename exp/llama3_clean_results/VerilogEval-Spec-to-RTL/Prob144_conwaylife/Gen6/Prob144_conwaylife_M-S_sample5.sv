module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;

integer row, col, index, new_row, new_col, count;

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (row = 0; row < 16; row++) begin
            for (col = 0; col < 16; col++) begin
                index = row * 16 + col;
                count = 0;
                for (integer i = -1; i <= 1; i++) begin
                    for (integer j = -1; j <= 1; j++) begin
                        if ((i == 0) && (j == 0)) begin
                            continue;
                        end
                        new_row = (row + i + 16) % 16;
                        new_col = (col + j + 16) % 16;
                        if (grid[new_row * 16 + new_col]) begin
                            count = count + 1;
                        end
                    end
                end
                case (count)
                    0, 1: grid[index] <= 1'b0;
                    2: grid[index] <= grid[index];
                    3: grid[index] <= 1'b1;
                    default: grid[index] <= 1'b0;
                endcase
            end
        end
    end
    q <= grid;
end

endmodule