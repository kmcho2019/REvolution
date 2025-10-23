module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out,
    output reg out_n
);
    always @(*) begin
        case ({a, b, c, d})
            4'b1100, 4'b0011: out = 1'b1;
            default: out = 1'b0;
        endcase
        out_n = ~out;
    end
endmodule