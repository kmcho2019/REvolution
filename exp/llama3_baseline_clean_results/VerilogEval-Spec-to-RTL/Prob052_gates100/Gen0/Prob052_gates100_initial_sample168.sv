module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

reg [99:0] in_reg;
reg and_result;
reg or_result;
reg xor_result;
integer count;

always @(*) begin
    and_result = 1;
    or_result = 0;
    xor_result = 0;
    count = 0;
    
    for (int i = 0; i < 100; i = i + 1) begin
        if (in[i] == 0) begin
            and_result = 0;
        end
        if (in[i] == 1) begin
            or_result = 1;
            count = count + 1;
        end
    end
    
    if (count % 2 == 1) begin
        xor_result = 1;
    end
end

assign out_and = and_result;
assign out_or = or_result;
assign out_xor = xor_result;

endmodule