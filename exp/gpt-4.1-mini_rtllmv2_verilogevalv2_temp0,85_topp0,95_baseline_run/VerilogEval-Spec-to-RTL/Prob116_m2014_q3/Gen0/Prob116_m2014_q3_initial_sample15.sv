module TopModule(
    input  [3:0] x,
    output      f
);

    // Map input bits: x[3] = MSB, x[0] = LSB
    // Index = {x[3], x[2], x[1], x[0]}

    reg f_reg;

    always @(*) begin
        case (x)
            4'b0000: f_reg = 1'b0; // d -> 0
            4'b0001: f_reg = 1'b0;
            4'b0010: f_reg = 1'b0; // d -> 0
            4'b0011: f_reg = 1'b0; // d -> 0

            4'b0100: f_reg = 1'b0;
            4'b0101: f_reg = 1'b0; // d -> 0
            4'b0110: f_reg = 1'b1;
            4'b0111: f_reg = 1'b0;

            4'b1100: f_reg = 1'b1;
            4'b1101: f_reg = 1'b1;
            4'b1110: f_reg = 1'b0; // d -> 0
            4'b1111: f_reg = 1'b0; // d -> 0

            4'b1000: f_reg = 1'b1;
            4'b1001: f_reg = 1'b1;
            4'b1010: f_reg = 1'b0;
            4'b1011: f_reg = 1'b0; // d -> 0

            default: f_reg = 1'b0;
        endcase
    end

    assign f = f_reg;

endmodule