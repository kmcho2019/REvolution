module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

reg [99:0] temp_in;
reg out_and_reg;
reg out_or_reg;
reg out_xor_reg;

always @(*)
begin
    temp_in = in;
    out_and_reg = 1'b1;
    out_or_reg = 1'b0;
    out_xor_reg = 1'b0;
    for (int i = 0; i < 100; i++)
    begin
        out_and_reg = out_and_reg & temp_in[i];
        out_or_reg = out_or_reg | temp_in[i];
        out_xor_reg = out_xor_reg ^ temp_in[i];
    end
    out_and = out_and_reg;
    out_or = out_or_reg;
    out_xor = out_xor_reg;
end

endmodule