module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    reg and_result = 1'b1;
    reg or_result = 1'b0;
    reg xor_result = 1'b0;

    integer i;
    always @(in) begin
        and_result = 1'b1;
        or_result = 1'b0;
        xor_result = 1'b0;
        for (i = 0; i < 100; i = i + 1) begin
            and_result = and_result & in[i];
            or_result = or_result | in[i];
            xor_result = xor_result ^ in[i];
        end
    end

    assign out_and = and_result;
    assign out_or = or_result;
    assign out_xor = xor_result;

endmodule