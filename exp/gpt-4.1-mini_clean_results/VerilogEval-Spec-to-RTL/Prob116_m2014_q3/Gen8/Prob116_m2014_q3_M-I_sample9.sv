module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output       f
);

    // Assign named wires for clarity
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Convert Gray-coded row bits (x3, x4) to binary row index
    // Gray to binary: b[1] = g[1]
    //                 b[0] = g[1] ^ g[0]
    wire row_gray1 = x3;
    wire row_gray0 = x4;
    wire row_bin1 = row_gray1;
    wire row_bin0 = row_gray1 ^ row_gray0;

    // Convert Gray-coded column bits (x1, x2) to binary column index
    wire col_gray1 = x1;
    wire col_gray0 = x2;
    wire col_bin1 = col_gray1;
    wire col_bin0 = col_gray1 ^ col_gray0;

    // Now row_bin = {row_bin1, row_bin0}, col_bin = {col_bin1, col_bin0}
    // Construct the 2D K-map index (row, col) in binary

    // Define a function that returns 1 for K-map cells with output=1,
    // 0 for 0 cells, and treat don't-cares as 0 for simplicity.

    // K-map in binary indices (row_bin,col_bin):
    // Row\Col  00   01   10   11
    //   00     d    0    d    d
    //   01     0    d    1    0
    //   10     1    1    0    d
    //   11     1    1    d    d

    // Convert above to a 4x4 binary indexed table:
    // row_bin\col_bin: row_bin1 row_bin0; col_bin1 col_bin0
    // Let's index row_bin as [1:0], col_bin as [1:0]

    // K-map values (row_bin, col_bin):
    // (0,0) = d -> 0
    // (0,1) = 0
    // (0,2) = d -> 0
    // (0,3) = d -> 0

    // (1,0) = 0
    // (1,1) = d -> 0
    // (1,2) = 1
    // (1,3) = 0

    // (2,0) = 1
    // (2,1) = 1
    // (2,2) = 0
    // (2,3) = d -> 0

    // (3,0) = 1
    // (3,1) = 1
    // (3,2) = d -> 0
    // (3,3) = d -> 0

    wire [1:0] row_idx = {row_bin1, row_bin0};
    wire [1:0] col_idx = {col_bin1, col_bin0};

    // Implement the function f with combinational logic based on these indices:
    reg f_reg;

    always @(*) begin
        case (row_idx)
            2'b00: // row 0
                case (col_idx)
                    2'b00: f_reg = 1'b0; // d treated as 0
                    2'b01: f_reg = 1'b0;
                    2'b10: f_reg = 1'b0;
                    2'b11: f_reg = 1'b0;
                    default: f_reg = 1'b0;
                endcase
            2'b01: // row 1
                case (col_idx)
                    2'b00: f_reg = 1'b0;
                    2'b01: f_reg = 1'b0;
                    2'b10: f_reg = 1'b1;
                    2'b11: f_reg = 1'b0;
                    default: f_reg = 1'b0;
                endcase
            2'b10: // row 2
                case (col_idx)
                    2'b00: f_reg = 1'b1;
                    2'b01: f_reg = 1'b1;
                    2'b10: f_reg = 1'b0;
                    2'b11: f_reg = 1'b0;
                    default: f_reg = 1'b0;
                endcase
            2'b11: // row 3
                case (col_idx)
                    2'b00: f_reg = 1'b1;
                    2'b01: f_reg = 1'b1;
                    2'b10: f_reg = 1'b0;
                    2'b11: f_reg = 1'b0;
                    default: f_reg = 1'b0;
                endcase
            default: f_reg = 1'b0;
        endcase
    end

    assign f = f_reg;

endmodule