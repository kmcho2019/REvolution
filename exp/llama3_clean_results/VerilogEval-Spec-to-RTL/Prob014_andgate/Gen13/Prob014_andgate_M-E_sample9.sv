module TopModule(a, b, out);
    output out;
    input a, b;
    reg out;

    always @(*) begin
        case ({a, b})
            2'b00: out = 1'b0;
            2'b01: out = 1'b0;
            2'b10: out = 1'b0;
            2'b11: out = 1'b1;
            default: out = 1'bx;
        endcase
    end
endmodule