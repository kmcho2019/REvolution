module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

reg out_reg;

always @(*)
begin
    case ({a, b, c, d})
        4'b0000, 4'b0001, 4'b0010, 4'b0101, 4'b0111, 4'b1000, 4'b1011, 4'b1110: out_reg = 1'b1;
        default: out_reg = 1'b0;
    endcase
end

assign out = out_reg;

endmodule