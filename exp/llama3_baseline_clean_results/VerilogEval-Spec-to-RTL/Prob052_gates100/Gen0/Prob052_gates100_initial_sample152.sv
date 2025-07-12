module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

reg and_temp;
reg or_temp;
reg xor_temp;

assign and_temp = 1'b1;
assign or_temp = 1'b0;
assign xor_temp = 1'b0;

always @(*) begin
    out_and = 1'b1;
    out_or = 1'b0;
    out_xor = 1'b0;
    
    for (int i = 0; i < 100; i++) begin
        out_and = out_and & in[i];
        out_or = out_or | in[i];
        out_xor = out_xor ^ in[i];
    end
end

endmodule