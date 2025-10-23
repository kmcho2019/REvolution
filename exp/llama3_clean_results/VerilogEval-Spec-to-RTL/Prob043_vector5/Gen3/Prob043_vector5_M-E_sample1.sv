module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

integer i, j;

always @(*) begin
    for (i = 0; i < 5; i++) begin
        for (j = 0; j < 5; j++) begin
            case ({i, j})
                5'd0: out[24] = (a == a);
                5'd1: out[23] = (a == b);
                5'd2: out[22] = (a == c);
                5'd3: out[21] = (a == d);
                5'd4: out[20] = (a == e);
                5'd5: out[19] = (b == a);
                5'd6: out[18] = (b == b);
                5'd7: out[17] = (b == c);
                5'd8: out[16] = (b == d);
                5'd9: out[15] = (b == e);
                5'd10: out[14] = (c == a);
                5'd11: out[13] = (c == b);
                5'd12: out[12] = (c == c);
                5'd13: out[11] = (c == d);
                5'd14: out[10] = (c == e);
                5'd15: out[9] = (d == a);
                5'd16: out[8] = (d == b);
                5'd17: out[7] = (d == c);
                5'd18: out[6] = (d == d);
                5'd19: out[5] = (d == e);
                5'd20: out[4] = (e == a);
                5'd21: out[3] = (e == b);
                5'd22: out[2] = (e == c);
                5'd23: out[1] = (e == d);
                5'd24: out[0] = (e == e);
            endcase
        end
    end
end

endmodule