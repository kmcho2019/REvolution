module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

reg mux_out;

always @(*) begin
    if (r) begin
        mux_out = 1'b0;
    end else begin
        mux_out = d;
    end
end

always @(posedge clk) begin
    q <= mux_out;
end

endmodule