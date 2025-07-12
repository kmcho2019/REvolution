module TopModule(
    input  [3:0] x,
    output      f
);

    wire [1:0] row = {x[3], x[0]};
    wire [1:0] col = {x[1], x[2]};
    wire [3:0] addr = {row, col};

    reg f_reg;

    always @(*) begin
        case(addr)
            4'b0000: f_reg = 1'b0; // row=00, col=00 -> d, choose 0
            4'b0001: f_reg = 1'b0; // row=00, col=01 -> 0
            4'b0010: f_reg = 1'b0; // row=00, col=11 -> d, choose 0
            4'b0011: f_reg = 1'b0; // row=00, col=10 -> d, choose 0

            4'b0100: f_reg = 1'b0; // row=01, col=00 -> 0
            4'b0101: f_reg = 1'b0; // row=01, col=01 -> d, choose 0
            4'b0110: f_reg = 1'b1; // row=01, col=11 -> 1
            4'b0111: f_reg = 1'b0; // row=01, col=10 -> 0

            4'b1100: f_reg = 1'b1; // row=11, col=00 -> 1
            4'b1101: f_reg = 1'b1; // row=11, col=01 -> 1
            4'b1110: f_reg = 1'b0; // row=11, col=11 -> d, choose 0
            4'b1111: f_reg = 1'b0; // row=11, col=10 -> d, choose 0

            4'b1000: f_reg = 1'b1; // row=10, col=00 -> 1
            4'b1001: f_reg = 1'b1; // row=10, col=01 -> 1
            4'b1010: f_reg = 1'b0; // row=10, col=11 -> 0
            4'b1011: f_reg = 1'b0; // row=10, col=10 -> d, choose 0

            default: f_reg = 1'b0; // default safe
        endcase
    end

    assign f = f_reg;

endmodule