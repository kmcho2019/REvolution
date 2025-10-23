module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg q
);
    always @(*) begin
        case ({b, c})
            2'b00: q = 0;
            default: q = 1;
        endcase
    end
endmodule