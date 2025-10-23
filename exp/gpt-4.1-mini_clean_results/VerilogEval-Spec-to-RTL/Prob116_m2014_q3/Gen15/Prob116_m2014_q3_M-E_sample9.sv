module TopModule (
    input  [3:0] x,  // Gray-coded inputs: x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output       f
);

    // Direct combinational assignment via case statement on Gray-coded input
    // Karnaugh map rewritten in terms of x as is (x4 x3 x2 x1)
    // Mapping from the problem's K-map (x4 x3 for rows, x2 x1 for cols)
    // Use don't cares (d) to choose output=0 for simplicity unless it can simplify the logic

    // The Karnaugh map from the problem, row= x4x3, col= x2x1:
    // x4x3\ x2x1 | 00 | 01 | 11 | 10
    //     00    | d  | 0  | d  | d
    //     01    | 0  | d  | 1  | 0
    //     11    | 1  | 1  | d  | d
    //     10    | 1  | 1  | 0  | d

    reg f_reg;
    always @(*) begin
        case (x)
            4'b0000: f_reg = 1'b0; // d, chosen 0
            4'b0001: f_reg = 1'b0;
            4'b0010: f_reg = 1'b0; // d, chosen 0
            4'b0011: f_reg = 1'b0; // d, chosen 0

            4'b0100: f_reg = 1'b0;
            4'b0101: f_reg = 1'b0; // d, chosen 0
            4'b0110: f_reg = 1'b1;
            4'b0111: f_reg = 1'b0;

            4'b1000: f_reg = 1'b1;
            4'b1001: f_reg = 1'b1;
            4'b1010: f_reg = 1'b0;
            4'b1011: f_reg = 1'b0; // d, chosen 0

            4'b1100: f_reg = 1'b1;
            4'b1101: f_reg = 1'b1;
            4'b1110: f_reg = 1'b0; // d, chosen 0
            4'b1111: f_reg = 1'b0; // d, chosen 0

            default: f_reg = 1'b0;
        endcase
    end

    assign f = f_reg;

endmodule