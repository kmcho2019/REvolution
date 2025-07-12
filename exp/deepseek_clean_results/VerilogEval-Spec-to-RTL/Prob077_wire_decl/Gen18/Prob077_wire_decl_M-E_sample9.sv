module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // Combined truth table implementation
    always @(*) begin
        case ({a, b, c, d})
            4'b0000: {out, out_n} = 2'b01;
            4'b0001: {out, out_n} = 2'b01;
            4'b0010: {out, out_n} = 2'b01;
            4'b0011: {out, out_n} = 2'b10;
            4'b0100: {out, out_n} = 2'b01;
            4'b0101: {out, out_n} = 2'b01;
            4'b0110: {out, out_n} = 2'b01;
            4'b0111: {out, out_n} = 2'b10;
            4'b1000: {out, out_n} = 2'b01;
            4'b1001: {out, out_n} = 2'b01;
            4'b1010: {out, out_n} = 2'b01;
            4'b1011: {out, out_n} = 2'b10;
            4'b1100: {out, out_n} = 2'b10;
            4'b1101: {out, out_n} = 2'b10;
            4'b1110: {out, out_n} = 2'b10;
            4'b1111: {out, out_n} = 2'b10;
        endcase
    end
endmodule