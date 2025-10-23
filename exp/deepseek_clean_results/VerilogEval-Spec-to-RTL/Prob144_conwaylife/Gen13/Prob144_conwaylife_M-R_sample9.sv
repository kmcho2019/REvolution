module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Precompute all possible wrapped positions
    wire [3:0] prev_row [15:0];
    wire [3:0] next_row [15:0];
    wire [3:0] prev_col [15:0];
    wire [3:0] next_col [15:0];
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : wrap_logic
            assign prev_row[i] = (i == 0) ? 15 : (i - 1);
            assign next_row[i] = (i == 15) ? 0 : (i + 1);
            assign prev_col[i] = (i == 0) ? 15 : (i - 1);
            assign next_col[i] = (i == 15) ? 0 : (i + 1);
        end
    endgenerate

    // Function to count neighbors for a given cell
    function [3:0] count_neighbors;
        input [255:0] grid;
        input [7:0] row;
        input [7:0] col;
        reg [3:0] row_p, row_n, col_p, col_n;
        begin
            row_p = prev_row[row];
            row_n = next_row[row];
            col_p = prev_col[col];
            col_n = next_col[col];
            
            count_neighbors = 
                grid[row_p*16 + col_p] +  // top-left
                grid[row_p*16 + col]   +  // top
                grid[row_p*16 + col_n] +  // top-right
                grid[row*16 + col_p]   +  // left
                grid[row*16 + col_n]    +  // right
                grid[row_n*16 + col_p] +  // bottom-left
                grid[row_n*16 + col]    +  // bottom
                grid[row_n*16 + col_n];    // bottom-right
        end
    endfunction

    // Next state calculation
    wire [255:0] next_q;
    generate
        for (i = 0; i < 256; i = i + 1) begin : next_state
            wire [3:0] row = i / 16;
            wire [3:0] col = i % 16;
            wire [3:0] neighbors = count_neighbors(q, row, col);
            
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