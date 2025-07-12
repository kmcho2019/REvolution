module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output reg [7:0] q
);

wire load_enable;
assign load_enable = reset | (d != q);

always @(negedge clk) begin
    if (reset) begin
        q <= 8'h34;
    end else if (load_enable) begin
        q <= d;
    end
end

endmodule