module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

function [2:0] count_neighbours;
    input [7:0] row;
    input [3:0] col;
    reg [2:0] count;
    begin
        count = 0;
        for (int i = -1; i <= 1; i++) begin
            for (int j = -1; j <= 1; j++) begin
                if ((i == 0) && (j == 0)) begin
                    continue;
                end
                int new_row = (row + i + 16) % 16;
                int new_col = (col + j + 16) % 16;
                int index = (new_row * 16) + new_col;
                if (q[index]) begin
                    count = count + 1;
                end
            end
        end
        count_neighbours = count;
    end
endfunction

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (int i = 0; i < 256; i++) begin
            int row = i / 16;
            int col = i % 16;
            reg [2:0] neighbours = count_neighbours(row, col);
            case (neighbours)
                0, 1: q[i] <= 0;
                2: q[i] <= q[i];
                3: q[i] <= 1;
                default: q[i] <= 0;
            endcase
        end
    end
end

endmodule