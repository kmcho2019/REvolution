module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    function [3:0] count_neighbors;
        input [255:0] grid;
        input [7:0] idx;
        reg [3:0] row, col;
        reg [7:0] n[0:7];
        begin
            row = idx >> 4;
            col = idx & 15;
            
            // Calculate neighbor positions with wrap-around
            n[0] = (((row - 1) & 15) << 4) | ((col - 1) & 15); // top-left
            n[1] = (((row - 1) & 15) << 4) | col;               // top
            n[2] = (((row - 1) & 15) << 4) | ((col + 1) & 15);  // top-right
            n[3] = (row << 4) | ((col - 1) & 15);               // left
            n[4] = (row << 4) | ((col + 1) & 15);               // right
            n[5] = (((row + 1) & 15) << 4) | ((col - 1) & 15);  // bottom-left
            n[6] = (((row + 1) & 15) << 4) | col;               // bottom
            n[7] = (((row + 1) & 15) << 4) | ((col + 1) & 15);  // bottom-right
            
            // 3-level adder tree for neighbor counting
            count_neighbors = grid[n[0]] + grid[n[1]] + grid[n[2]] + 
                             grid[n[3]] + grid[n[4]] + 
                             grid[n[5]] + grid[n[6]] + grid[n[7]];
        end
    endfunction

    wire [255:0] next_q;
    integer i;
    
    // Calculate next state for all cells
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_update
            wire [3:0] neighbors = count_neighbors(q, i);
            assign next_q[i] = (neighbors == 3) ? 1'b1 :
                              (neighbors == 2) ? q[i] :
                              1'b0;
        end
    endgenerate

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule