module TopModule (
    input  wire clk,
    input  wire d,
    input  wire r,
    output reg  q
);

reg d_latched;

always @(posedge clk) begin
    d_latched <= d;
end

always @(posedge clk) begin
    if (r)
        q <= 1'b0;
    else
        q <= d_latched;
end

endmodule