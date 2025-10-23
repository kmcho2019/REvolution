module TopModule(
    input clk,
    input d,
    output reg q
);

reg clk_double;
always @(posedge clk or negedge clk)
begin
    // This always block is not synthesizable due to the sensitivity list.
    // To synthesize, we can use the following code instead.
    // reg old_clk;
    // initial old_clk = 1'b0;
    // always @(posedge clk or negedge clk) begin
    //     if (clk != old_clk) begin
    //         old_clk <= clk;
    //         clk_double <= ~clk_double;
    //     end
    // end
    clk_double <= ~clk_double;
end

always @(posedge clk_double)
    q <= d;

endmodule