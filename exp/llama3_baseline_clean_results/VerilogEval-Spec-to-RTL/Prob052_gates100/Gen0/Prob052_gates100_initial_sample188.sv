module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

reg and_result;
reg or_result;
reg xor_result;

always @(*) begin
    and_result = 1'b1;
    or_result = 1'b0;
    xor_result = 1'b0;
    
    for (int i = 0; i <= 99; i++) begin
        and_result = and_result & in[i];
        or_result = or_result | in[i];
        xor_result = xor_result ^ in[i];
    end
    
    out_and = and_result;
    out_or = or_result;
    out_xor = xor_result;
end

endmodule