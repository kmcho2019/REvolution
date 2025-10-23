module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

reg mux_out;

always @(*) begin
    if (ar) begin
        mux_out = 0;
    end else begin
        mux_out = d;
    end
end

always @(posedge clk) begin
    q <= mux_out;
end

endmodule