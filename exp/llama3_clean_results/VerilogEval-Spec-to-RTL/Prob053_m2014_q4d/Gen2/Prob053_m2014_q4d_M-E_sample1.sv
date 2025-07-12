module TopModule(
    input clk,
    input in,
    output reg out
);

reg captured_in;
reg captured_out;
reg xor_result;

always @(posedge clk) begin
    captured_in <= in;
    captured_out <= out;
end

always @(*) begin
    xor_result = captured_in ^ captured_out;
end

always @(posedge clk) begin
    out <= xor_result;
end

endmodule