module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

reg [99:0] temp_in;
reg and_result;
reg or_result;
reg xor_result;

initial begin
    temp_in = in;
    and_result = 1'b1;
    or_result = 1'b0;
    xor_result = 1'b0;
    for (int i = 0; i < 100; i++) begin
        and_result = and_result & temp_in[i];
        or_result = or_result | temp_in[i];
        xor_result = xor_result ^ temp_in[i];
    end
    out_and = and_result;
    out_or = or_result;
    out_xor = xor_result;
end

always @(*) begin
    temp_in = in;
    and_result = 1'b1;
    or_result = 1'b0;
    xor_result = 1'b0;
    for (int i = 0; i < 100; i++) begin
        and_result = and_result & temp_in[i];
        or_result = or_result | temp_in[i];
        xor_result = xor_result ^ temp_in[i];
    end
    out_and = and_result;
    out_or = or_result;
    out_xor = xor_result;
end

endmodule