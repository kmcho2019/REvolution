module TopModule(
    input  a,
    input  b,
    output out
);

reg out_reg;

always @(*) begin
    case ({a, b})
        2'b00: out_reg = 1'b0;
        2'b01: out_reg = 1'b0;
        2'b10: out_reg = 1'b0;
        2'b11: out_reg = 1'b1;
        default: out_reg = 1'b0;
    endcase
end

assign out = out_reg;

endmodule