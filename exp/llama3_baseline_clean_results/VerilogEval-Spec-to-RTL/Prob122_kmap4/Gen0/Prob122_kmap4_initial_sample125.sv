module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    reg out_reg;
    assign out = out_reg;

    always @(a, b, c, d) begin
        case ({c, d})
            2'b00: out_reg = (a == 1'b0 && b == 1'b1) || (a == 1'b1 && b == 1'b0);
            2'b01: out_reg = (a == 1'b0 && b == 1'b0) || (a == 1'b1 && b == 1'b1);
            2'b11: out_reg = (a == 1'b0 && b == 1'b1) || (a == 1'b1 && b == 1'b0);
            2'b10: out_reg = (a == 1'b0 && b == 1'b0) || (a == 1'b1 && b == 1'b1);
            default: out_reg = 1'b0;
        endcase
    end

endmodule