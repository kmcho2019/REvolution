module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Function to count the number of alive neighbors for a given cell
function [3:0] count_neighbors;
    input [255:0] q;
    input [7:0] row, col;
    reg [3:0] count_neighbors;
    begin
        count_neighbors = 0;
        for (int i = -1; i <= 1; i++) begin
            for (int j = -1; j <= 1; j++) begin
                if ((i == 0) && (j == 0)) continue;
                count_neighbors = count_neighbors + q[(row + i + 16) % 16 * 16 + (col + j + 16) % 16];
            end
        end
    end
end

// Update the state of each cell based on the counting result
always @(posedge clk) begin
    reg [255:0] q_next;
    if (load) begin
        q <= data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [3:0] neighbors;
                neighbors = count_neighbors(q, i, j);
                case (neighbors)
                    0, 1: q_next[i*16 + j] = 0;
                    2: q_next[i*16 + j] = q[i*16 + j];
                    3: q_next[i*16 + j] = 1;
                    default: q_next[i*16 + j] = 0;
                endcase
            end
        end
        q <= q_next;
    end
end

endmodule