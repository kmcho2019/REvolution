module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg xor_out = 1'b0;
reg and_out = 1'b0;
reg or_out = 1'b0;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        xor_out <= 1'b0;
        and_out <= 1'b0;
        or_out <= 1'b0;
    end else begin
        xor_out <= x ^ xor_out;
        and_out <= x & ~and_out;
        or_out <= x | ~or_out;
    end
end

assign z = ~(xor_out | and_out | or_out);

endmodule