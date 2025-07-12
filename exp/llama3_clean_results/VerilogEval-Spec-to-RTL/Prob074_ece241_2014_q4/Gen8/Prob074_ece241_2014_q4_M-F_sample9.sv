module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_out = 1'b0, and_out = 1'b0, or_out = 1'b0;

always @(posedge clk) begin
    reg xor_temp, and_temp, or_temp;
    xor_temp = x ^ xor_out;
    and_temp = x & ~and_out;
    or_temp = x | ~or_out;
    xor_out <= xor_temp;
    and_out <= and_temp;
    or_out <= or_temp;
    z <= ~(xor_temp | and_temp | or_temp);
end

endmodule