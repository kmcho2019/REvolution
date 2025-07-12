module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

// Function to count the number of neighbors for a cell
function [3:0] count_neighbors;
    input [15:0] row;
    input [3:0] col;
    reg [3:0] count;
    integer i, j;

    count = 0;
    for (i = -1; i <= 1; i = i + 1) begin
        for (j = -1; j <= 1; j = j + 1) begin
            if ((i != 0 || j != 0) && q[((((row + i) % 16) * 16) + ((col + j) % 16)) +:1] == 1'b1) begin
                count = count + 1;
            end
        end
    end
    count_neighbors = count;
endfunction

// Combinatorial logic to calculate the next state
always @(*) begin
    integer i, j;

    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            case (count_neighbors(i, j))
                0, 1: next_q[(i * 16) + j] = 1'b0;
                2: next_q[(i * 16) + j] = q[(i * 16) + j];
                3: next_q[(i * 16) + j] = 1'b1;
                default: next_q[(i * 16) + j] = 1'b0;
            endcase
        end
    end
end

// Sequential logic to update the game state
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule