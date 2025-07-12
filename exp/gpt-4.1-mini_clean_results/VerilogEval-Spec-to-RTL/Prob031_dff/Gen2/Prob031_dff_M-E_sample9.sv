module TopModule (
    input clk,
    input d,
    output reg q
);

reg d_latched;

always @(*) begin
    d_latched = d;
end

always @(posedge clk) begin
    q <= d_latched;
end

endmodule