module TopModule (
    input  [3:0] x,  // x[3] (MSB), x[2], x[1], x[0] (LSB)
    output       f
);

    // Extract row and column bits from input
    wire [1:0] row = x[3:2]; // x[3], x[2]
    wire [1:0] col_bin = x[1:0]; // x[1], x[0]

    // Convert column binary to Gray code index used in Karnaugh map (00,01,11,10)
    // Binary to Gray order mapping:
    // bin  col | Gray index
    // 00 (0)   | 0
    // 01 (1)   | 1
    // 10 (2)   | 3
    // 11 (3)   | 2

    reg [1:0] col_gray;
    always @(*) begin
        case (col_bin)
            2'b00: col_gray = 2'd0;
            2'b01: col_gray = 2'd1;
            2'b11: col_gray = 2'd2;
            2'b10: col_gray = 2'd3;
            default: col_gray = 2'd0; // Should not happen
        endcase
    end

    // Now implement f based on Karnaugh map 1-cells:

    // Cells with f=1:
    // row col (gray) | meaning
    // (01,11) => row=1, col=2
    // (11,00) => row=3, col=0
    // (11,01) => row=3, col=1
    // (10,00) => row=2, col=0
    // (10,01) => row=2, col=1

    // f = OR of these minterms:

    wire cond_1 = (row == 2'b01) && (col_gray == 2'b10);
    wire cond_2 = (row == 2'b11) && (col_gray == 2'b00);
    wire cond_3 = (row == 2'b11) && (col_gray == 2'b01);
    wire cond_4 = (row == 2'b10) && (col_gray == 2'b00);
    wire cond_5 = (row == 2'b10) && (col_gray == 2'b01);

    assign f = cond_1 | cond_2 | cond_3 | cond_4 | cond_5;

endmodule