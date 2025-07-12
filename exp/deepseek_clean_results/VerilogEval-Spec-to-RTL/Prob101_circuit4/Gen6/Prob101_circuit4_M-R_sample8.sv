module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg q
);

    always @(*) begin
        case ({b, c})
            2'b00: q = 1'b0;
            default: q = 1'b1;
        endcase
    end

endmodule