module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    if (r)
        q <= 1'b0;  // synchronous reset
    else if (d != q)
        q <= d;     // update only if new data differs to reduce toggling
end

endmodule