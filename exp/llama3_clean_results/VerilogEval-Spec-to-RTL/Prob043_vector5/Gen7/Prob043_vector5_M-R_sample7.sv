module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

reg [24:0] out_reg;

always @(*) begin
    out_reg = 25'd0;
    for (int i = 0; i < 5; i++) begin
        for (int j = 0; j < 5; j++) begin
            case ({i, j})
                5'd0: out_reg[24] = ~(a ^ a);
                5'd1: out_reg[23] = ~(a ^ b);
                5'd2: out_reg[22] = ~(a ^ c);
                5'd3: out_reg[21] = ~(a ^ d);
                5'd4: out_reg[20] = ~(a ^ e);
                5'd5: out_reg[19] = ~(b ^ a);
                5'd6: out_reg[18] = ~(b ^ b);
                5'd7: out_reg[17] = ~(b ^ c);
                5'd8: out_reg[16] = ~(b ^ d);
                5'd9: out_reg[15] = ~(b ^ e);
                5'd10: out_reg[14] = ~(c ^ a);
                5'd11: out_reg[13] = ~(c ^ b);
                5'd12: out_reg[12] = ~(c ^ c);
                5'd13: out_reg[11] = ~(c ^ d);
                5'd14: out_reg[10] = ~(c ^ e);
                5'd15: out_reg[9] = ~(d ^ a);
                5'd16: out_reg[8] = ~(d ^ b);
                5'd17: out_reg[7] = ~(d ^ c);
                5'd18: out_reg[6] = ~(d ^ d);
                5'd19: out_reg[5] = ~(d ^ e);
                5'd20: out_reg[4] = ~(e ^ a);
                5'd21: out_reg[3] = ~(e ^ b);
                5'd22: out_reg[2] = ~(e ^ c);
                5'd23: out_reg[1] = ~(e ^ d);
                5'd24: out_reg[0] = ~(e ^ e);
                default: out_reg = 25'd0;
            endcase
        end
    end
    out = out_reg;
end

endmodule