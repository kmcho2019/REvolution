module TopModule (
    input  wire clk,
    input  wire d,
    input  wire r,
    output reg  q
);

reg mux_out;

always @(*) begin
    if (r)
        mux_out = 1'b0;
    else
        mux_out = d;
end

always @(posedge clk) begin
    q <= mux_out;
end

endmodule