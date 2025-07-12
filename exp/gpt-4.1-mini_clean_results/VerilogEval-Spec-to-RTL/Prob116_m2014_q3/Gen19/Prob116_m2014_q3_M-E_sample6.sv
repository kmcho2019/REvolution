module TopModule (
    input  [3:0] x, // Gray-coded input vector: x[3]=x4 ... x[0]=x1
    output      f
);

    reg f_reg;

    always @(*) begin
        case (x)
            4'b0000: f_reg = 1'b0; // x=0000: d -> 0
            4'b0001: f_reg = 1'b0; // 0001: 0
            4'b0010: f_reg = 1'b0; // 0010: d -> 0
            4'b0011: f_reg = 1'b0; // 0011: d -> 0

            4'b0100: f_reg = 1'b0; // 0100: 0
            4'b0101: f_reg = 1'b0; // 0101: d -> 0
            4'b0110: f_reg = 1'b1; // 0110: 1
            4'b0111: f_reg = 1'b0; // 0111: 0

            4'b1000: f_reg = 1'b1; // 1000: 1
            4'b1001: f_reg = 1'b1; // 1001: 1
            4'b1010: f_reg = 1'b0; // 1010: 0
            4'b1011: f_reg = 1'b0; // 1011: d -> 0

            4'b1100: f_reg = 1'b1; // 1100: 1
            4'b1101: f_reg = 1'b1; // 1101: 1
            4'b1110: f_reg = 1'b0; // 1110: d -> 0
            4'b1111: f_reg = 1'b0; // 1111: d -> 0

            default: f_reg = 1'b0;  // default safe fallback
        endcase
    end

    assign f = f_reg;

endmodule