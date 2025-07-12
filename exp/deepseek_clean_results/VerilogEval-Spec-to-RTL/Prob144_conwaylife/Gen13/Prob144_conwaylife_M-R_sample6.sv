module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    function [3:0] count_neighbors;
        input [255:0] grid;
        input [7:0] index;
        reg [3:0] row, col;
        reg [3:0] row_p1, row_m1, col_p1, col_m1;
        begin
            row = index[7:4];
            col = index[3:0];
            
            // Calculate wrapped positions
            row_p1 = row + 4'd1;
            row_m1 = row - 4'd1;
            col_p1 = col + 4'd1;
            col_m1 = col - 4'd1;
            
            // Count all 8 neighbors with wrap-around
            count_neighbors = 
                grid[{row_p1, col_p1}] + grid[{row_p1, col}] + grid[{row_p1, col_m1}] +
                grid[{row, col_p1}] + grid[{row, col_m1}] +
                grid[{row_m1, col_p1}] + grid[{row_m1, col}] + grid[{row_m1, col_m1}];
        end
    endfunction

    wire [255:0] next_q;
    wire [255:0] cell_stable;
    
    // Calculate next state and stability in parallel
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_update
            wire [3:0] neighbors = count_neighbors(q, i);
            wire current = q[i];
            
            assign cell_stable[i] = (neighbors == 4'd2) & current;
            assign next_q[i] = (neighbors == 4'd3) ? 1'b1 :
                              (neighbors == 4'd2) ? current :
                              1'b0;
        end
    endgenerate

    // Update logic using bitwise operations
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= (q & cell_stable) | (next_q & ~cell_stable);
        end
    end

endmodule