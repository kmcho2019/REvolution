module TopModule(
    input  [3:0] x,
    output      f
);
    // Mapping:
    // Rows: x[2]x[3]
    // Cols: x[0]x[1]
    // Indices reordered to match bit order: Let's consider input as x[3],x[2],x[1],x[0]
    // The Karnaugh map is given as:
    // x[2]x[3] \ x[0]x[1]
    //       00  01  11  10
    // 00 |  1 | 0 | 0 | 1 |
    // 01 |  0 | 0 | 0 | 0 |
    // 11 |  1 | 1 | 1 | 0 |
    // 10 |  1 | 1 | 0 | 1 |

    // Note: The problem states rows as x[2]x[3], columns as x[0]x[1],
    // but inputs are given as x[3:0]. To match the map, we consider:
    // row_index = {x[2], x[3]} (2 bits)
    // col_index = {x[0], x[1]} (2 bits)
    // So address in map is: row = (x[2]<<1) + x[3], col = (x[0]<<1) + x[1]

    // To access minterms correctly, reconstruct x as:
    // x = {x[3], x[2], x[1], x[0]}
    // But the map uses row = {x[2], x[3]}, col = {x[0], x[1]}

    // So the minterms correspond to 4-bit inputs: {x[3], x[2], x[1], x[0]}
    // Let's list all 16 input combinations, assign f=1 where the map has 1.

    wire [1:0] row = {x[2], x[3]};
    wire [1:0] col = {x[0], x[1]};

    reg f_reg;

    always @(*) begin
        case ({row, col}) // 4-bit index: row[1:0],col[1:0]
            4'b0000: f_reg = 1; // row=00 col=00
            4'b0001: f_reg = 0; // 00 01
            4'b0011: f_reg = 0; // 00 11
            4'b0010: f_reg = 1; // 00 10

            4'b0100: f_reg = 0; // 01 00
            4'b0101: f_reg = 0; // 01 01
            4'b0111: f_reg = 0; // 01 11
            4'b0110: f_reg = 0; // 01 10

            4'b1100: f_reg = 1; // 11 00
            4'b1101: f_reg = 1; // 11 01
            4'b1111: f_reg = 1; // 11 11
            4'b1110: f_reg = 0; // 11 10

            4'b1000: f_reg = 1; // 10 00
            4'b1001: f_reg = 1; // 10 01
            4'b1011: f_reg = 0; // 10 11
            4'b1010: f_reg = 1; // 10 10

            default: f_reg = 0;
        endcase
    end

    assign f = f_reg;

endmodule