module TopModule(
    input  [3:0] x,  // x[3], x[2], x[1], x[0]
    output        f
);

    // Map input bits to Karnaugh map indices:
    // Rows indexed by Gray code of {x[3], x[0]}
    // Columns indexed by Gray code of {x[1], x[2]}

    // Function to convert 2-bit binary to Gray code index (0 to 3)
    function [1:0] bin2gray(input [1:0] bin);
        begin
            bin2gray = bin ^ (bin >> 1);
        end
    endfunction

    // Define Karnaugh map values as a 4x4 constant array
    // Rows: Gray code of {x[3], x[0]} (00,01,11,10)
    // Columns: Gray code of {x[1], x[2]} (00,01,11,10)
    // Using don't-cares = 0 for simplicity
    localparam [0:0] kmap [0:3][0:3] = '{
        '{1'b0, 1'b0, 1'b0, 1'b0},  // row=00
        '{1'b0, 1'b0, 1'b1, 1'b0},  // row=01
        '{1'b1, 1'b1, 1'b0, 1'b0},  // row=11
        '{1'b1, 1'b1, 1'b0, 1'b0}   // row=10
    };

    wire [1:0] row_bin = {x[3], x[0]};
    wire [1:0] col_bin = {x[1], x[2]};

    wire [1:0] row_idx = bin2gray(row_bin);
    wire [1:0] col_idx = bin2gray(col_bin);

    assign f = kmap[row_idx][col_idx];

endmodule