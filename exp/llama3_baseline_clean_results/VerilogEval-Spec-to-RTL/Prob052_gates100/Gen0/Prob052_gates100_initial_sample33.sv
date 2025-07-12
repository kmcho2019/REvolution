module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

reg and_out;
reg or_out;
reg xor_out;

always @(in) begin
    and_out = 1'b1;
    or_out = 1'b0;
    xor_out = 1'b0;
    
    for (int i = 0; i < 100; i++) begin
        and_out = and_out & in[i];
        or_out = or_out | in[i];
        xor_out = xor_out ^ in[i];
    end
end

assign out_and = and_out;
assign out_or = or_out;
assign out_xor = xor_out;

endmodule