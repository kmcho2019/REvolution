module TopModule (
    input  [3:0] x,
    output      f
);

    // x[3], x[2] = row index
    // x[1], x[0] = column index
    // Karnaugh map with indices: rows = x[3:2], columns = x[1:0]
    // Entries with 1s:
    // row=00 (x[3:2]=00): col=00,10 -> minterms 0b0000=0, 0b0010=2
    // row=01 (x[3:2]=01): none
    // row=11 (x[3:2]=11): col=00,01,11 -> minterms 0b1100=12,0b1101=13,0b1111=15
    // row=10 (x[3:2]=10): col=00,01,10 -> minterms 0b1000=8,0b1001=9,0b1010=10

    // Implement logic using a case statement for clarity

    reg f_reg;
    always @(*) begin
        case (x)
            4'b0000: f_reg = 1;
            4'b0010: f_reg = 1;
            4'b1100: f_reg = 1;
            4'b1101: f_reg = 1;
            4'b1111: f_reg = 1;
            4'b1000: f_reg = 1;
            4'b1001: f_reg = 1;
            4'b1010: f_reg = 1;
            default: f_reg = 0;
        endcase
    end

    assign f = f_reg;

endmodule