module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    function [3:0] count_neighbors;
        input [255:0] grid;
        input [7:0] row, col;
        reg [3:0] count;
        integer i, j;
        begin
            count = 0;
            for (i = -1; i <= 1; i = i + 1) begin
                for (j = -1; j <= 1; j = j + 1) begin
                    if (i != 0 || j != 0) begin  // Skip self
                        count = count + grid[((row + i + 16) % 16 * 16 + ((col + j + 16) % 16)];
                    end
                end
            end
            count_neighbors = count;
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer i = 0; i < 16; i = i + 1) begin
                for (integer j = 0; j < 16; j = j + 1) begin
                    case (count_neighbors(q, i, j))
                        2: q[i*16 + j] <= q[i*16 + j];  // No change
                        3: q[i*16 + j] <= 1'b1;         // Birth
                        default: q[i*16 + j] <= 1'b0;   // Death
                    endcase
                end
            end
        end
    end

endmodule