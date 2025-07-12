module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

    always @(a, b, c, d) begin
        case ({a, b, c, d})
            4'b0000, 4'b0001, 4'b0010, 4'b0101, 4'b0110, 4'b1010, 4'b1011, 4'b1101, 4'b1110, 4'b1111: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule