module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    reg [99:0] in_reg;
    assign in_reg = in;

    always @(in) begin
        reg and_result = 1'b1;
        reg or_result = 1'b0;
        reg xor_result = 1'b0;
        for (int i = 0; i <= 99; i++) begin
            and_result = and_result & in_reg[i];
            or_result = or_result | in_reg[i];
            xor_result = xor_result ^ in_reg[i];
        end
        assign out_and = and_result;
        assign out_or = or_result;
        assign out_xor = xor_result;
    end

endmodule