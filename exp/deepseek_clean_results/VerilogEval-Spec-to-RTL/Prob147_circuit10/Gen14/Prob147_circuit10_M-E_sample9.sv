module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg prev_a = 1'b0;

always @(posedge clk) begin
    prev_a <= a;
end

assign q = (a & prev_a) ^ b;
assign state = prev_a;

endmodule