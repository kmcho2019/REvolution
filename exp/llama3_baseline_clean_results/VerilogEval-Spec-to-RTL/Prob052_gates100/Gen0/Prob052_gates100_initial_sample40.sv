module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

reg and_temp;
reg or_temp;
reg xor_temp;

always @(*) begin
    and_temp = 1'b1;
    or_temp = 1'b0;
    xor_temp = 1'b0;

    for (int i = 0; i < 100; i = i + 1) begin
        and_temp = and_temp & in[i];
        or_temp = or_temp | in[i];
        xor_temp = xor_temp ^ in[i];
    end

    out_and = and_temp;
    out_or = or_temp;
    out_xor = xor_temp;
end

endmodule