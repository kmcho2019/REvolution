module TopModule(
    input [3:0] x,
    output f
);

    // Introduction of intermediate signals for x[0] and x[1]
    wire x0_x1_00, x0_x1_10;

    assign x0_x1_00 = ~x[0] & ~x[1];
    assign x0_x1_10 = x[0] & ~x[1];

    reg f_reg;
    always @(*) begin
        case ({x[2], x[3]})
            2'b00: f_reg = x0_x1_00 | x0_x1_10;
            2'b01: f_reg = 1'b0;
            2'b11: f_reg = x0_x1_00 | ~x[0] & x[1] | x[0] & x[1];
            2'b10: f_reg = x0_x1_00 | ~x[0] & x[1] | x0_x1_10;
            default: f_reg = 1'b0;
        endcase
    end

    assign f = f_reg;

endmodule