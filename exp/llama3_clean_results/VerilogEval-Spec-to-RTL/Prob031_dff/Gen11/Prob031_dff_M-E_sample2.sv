module TopModule(
    input clk,
    input d,
    output reg q
);

reg mux_out;

always @(posedge clk) begin
    q <= mux_out;
end

always @(*) begin
    if (~clk) begin
        mux_out = q;
    end else begin
        mux_out = d;
    end
end

endmodule