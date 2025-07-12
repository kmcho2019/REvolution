module TopModule(a, b, c, d, out);
    input a, b, c, d;
    output out;

    always @(*) begin
        case ({a, b, c, d})
            4'b0000, 4'b0001, 4'b0010, 4'b0100, 4'b0101, 4'b1010, 4'b1011, 4'b1100: out = 1'b1;
            default: out = 1'b0;
        endcase
    end
endmodule