module TopModule(
    input  clk,
    input  load,
    input  [255:0] data,
    output reg [255:0] q
);

reg [255:0] q_next;

// Function to count the number of neighbors for a given cell
function [3:0] count_neighbors;
    input [15:0] row;
    input [15:0] col;
    input [255:0] q;
    reg [3:0] count;
    reg [15:0] i, j;
    reg [15:0] row_mod, col_mod;

    count = 0;
    for (i = -1; i <= 1; i = i + 1) begin
        for (j = -1; j <= 1; j = j + 1) begin
            if (i == 0 && j == 0)
                continue;
            row_mod = (row + i + 16) % 16;
            col_mod = (col + j + 16) % 16;
            count = count + q[row_mod * 16 + col_mod];
        end
    end
    count_neighbors = count;
endfunction

// Update the state of the grid
always @(*) begin
    if (load) begin
        q_next = data;
    end else begin
        for (int i = 0; i < 16; i = i + 1) begin
            for (int j = 0; j < 16; j = j + 1) begin
                reg [3:0] neighbors;
                neighbors = count_neighbors(i, j, q);
                case (neighbors)
                    0, 1: q_next[i * 16 + j] = 0;
                    2: q_next[i * 16 + j] = q[i * 16 + j];
                    3: q_next[i * 16 + j] = 1;
                    default: q_next[i * 16 + j] = 0;
                endcase
            end
        end
    end
end

// Update q on the positive edge of the clock
always @(posedge clk) begin
    q <= q_next;
end

endmodule