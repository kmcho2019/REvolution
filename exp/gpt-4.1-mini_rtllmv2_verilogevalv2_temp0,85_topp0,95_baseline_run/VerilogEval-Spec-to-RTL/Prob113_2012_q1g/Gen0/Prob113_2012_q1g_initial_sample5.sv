module TopModule(
    input  [3:0] x,
    output      f
);
    // Assign row = x[3:2], col = x[1:0]
    wire [1:0] row = x[3:2];
    wire [1:0] col = x[1:0];

    // Map the Karnaugh map as per given table:
    // row\col  00  01  11  10
    //  00      1   0   0   1
    //  01      0   0   0   0
    //  11      1   1   1   0
    //  10      1   1   0   1

    // Implement with a case statement
    reg f_reg;
    always @(*) begin
        case ({row, col})
            6'b0000_00: f_reg = 1; // row=00 col=00
            6'b0000_01: f_reg = 0;
            6'b0000_11: f_reg = 0;
            6'b0000_10: f_reg = 1;

            6'b0001_00: f_reg = 0;
            6'b0001_01: f_reg = 0;
            6'b0001_11: f_reg = 0;
            6'b0001_10: f_reg = 0;

            6'b0011_00: f_reg = 1;
            6'b0011_01: f_reg = 1;
            6'b0011_11: f_reg = 1;
            6'b0011_10: f_reg = 0;

            6'b0010_00: f_reg = 1;
            6'b0010_01: f_reg = 1;
            6'b0010_11: f_reg = 0;
            6'b0010_10: f_reg = 1;

            default: f_reg = 0;
        endcase
    end

    assign f = f_reg;
endmodule