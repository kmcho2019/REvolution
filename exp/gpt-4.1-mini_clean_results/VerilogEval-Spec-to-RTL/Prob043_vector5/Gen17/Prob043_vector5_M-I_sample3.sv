module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Inputs packed into an array for indexing
    wire [4:0] in_arr = {a, b, c, d, e};

    // Declare a 5x5 temporary array for pairwise comparison results
    wire [4:0] row_results [4:0];  // row_results[row][col]

    genvar row, col;
    
    // Compute only upper triangle (row <= col) XNORs
    generate
        for (row = 0; row < 5; row = row + 1) begin : gen_rows
            for (col = row; col < 5; col = col + 1) begin : gen_cols_upper
                assign row_results[row][col] = ~(in_arr[row] ^ in_arr[col]);
            end
        end
    endgenerate

    // Assign lower triangle (row > col) by symmetric mapping
    generate
        for (row = 0; row < 5; row = row + 1) begin : gen_rows_lower
            for (col = 0; col < row; col = col + 1) begin : gen_cols_lower
                assign row_results[row][col] = row_results[col][row];
            end
        end
    endgenerate

    // Function to calculate output bit index based on row and col
    // out index = 24 - (row*5 + col)
    function integer bit_index(input integer r, input integer c);
        begin
            bit_index = 24 - (r*5 + c);
        end
    endfunction

    // Flatten 2D array into output vector
    generate
        for (row = 0; row < 5; row = row + 1) begin : gen_out_row
            for (col = 0; col < 5; col = col + 1) begin : gen_out_col
                localparam integer idx = bit_index(row, col);
                assign out[idx] = row_results[row][col];
            end
        end
    endgenerate

endmodule