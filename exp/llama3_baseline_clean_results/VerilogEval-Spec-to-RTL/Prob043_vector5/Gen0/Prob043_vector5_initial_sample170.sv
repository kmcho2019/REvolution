module TopModule(
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

reg [24:0] out_reg;

always @(*) begin
    integer i, j, k;
    out_reg = 25'b0; // initialize out_reg to 0

    k = 24; // initialize counter
    for (i = 0; i < 5; i = i + 1) begin
        for (j = 0; j < 5; j = j + 1) begin
            case ({i, j})
                2'b00: out_reg[k] = ~(a ^ a);
                2'b01: out_reg[k] = ~(a ^ b);
                2'b02: out_reg[k] = ~(a ^ c);
                2'b03: out_reg[k] = ~(a ^ d);
                2'b04: out_reg[k] = ~(a ^ e);
                2'b10: out_reg[k] = ~(b ^ a);
                2'b11: out_reg[k] = ~(b ^ b);
                2'b12: out_reg[k] = ~(b ^ c);
                2'b13: out_reg[k] = ~(b ^ d);
                2'b14: out_reg[k] = ~(b ^ e);
                2'b20: out_reg[k] = ~(c ^ a);
                2'b21: out_reg[k] = ~(c ^ b);
                2'b22: out_reg[k] = ~(c ^ c);
                2'b23: out_reg[k] = ~(c ^ d);
                2'b24: out_reg[k] = ~(c ^ e);
                2'b30: out_reg[k] = ~(d ^ a);
                2'b31: out_reg[k] = ~(d ^ b);
                2'b32: out_reg[k] = ~(d ^ c);
                2'b33: out_reg[k] = ~(d ^ d);
                2'b34: out_reg[k] = ~(d ^ e);
                2'b40: out_reg[k] = ~(e ^ a);
                2'b41: out_reg[k] = ~(e ^ b);
                2'b42: out_reg[k] = ~(e ^ c);
                2'b43: out_reg[k] = ~(e ^ d);
                2'b44: out_reg[k] = ~(e ^ e);
            endcase
            k = k - 1; // decrement counter
        end
    end
    out = out_reg;
end

endmodule