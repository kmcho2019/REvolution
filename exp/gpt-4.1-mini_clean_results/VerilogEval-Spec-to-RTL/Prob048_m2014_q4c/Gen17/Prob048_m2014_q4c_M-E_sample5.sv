module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

reg d_reg;

always @(posedge clk) begin
    d_reg <= d; // sample input d
end

always @(posedge clk) begin
    if (r)
        q <= 1'b0; // synchronous reset
    else
        q <= d_reg; // update output with sampled value
end

endmodule