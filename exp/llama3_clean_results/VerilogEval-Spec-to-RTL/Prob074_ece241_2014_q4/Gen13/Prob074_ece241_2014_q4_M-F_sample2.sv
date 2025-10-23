module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out = 1'b0;
reg and_out = 1'b0;
reg or_out = 1'b0;

always @(posedge clk) begin
    reg xor_out_next;
    reg and_out_next;
    reg or_out_next;
    
    xor_out_next = x ^ xor_out;
    and_out_next = x & ~and_out;
    or_out_next = x | ~or_out;
    
    xor_out <= xor_out_next;
    and_out <= and_out_next;
    or_out <= or_out_next;
end

assign z = ~(xor_out | and_out | or_out);

endmodule