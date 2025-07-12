module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

always @(*)
begin
    case ({c, d, a, b})
        4'b0000, 4'b0001, 4'b0111, 4'b1010: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule