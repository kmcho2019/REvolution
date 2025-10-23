module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_d;
reg prev_clk;

always @(posedge clk)
    prev_clk <= clk;

always @(negedge clk or posedge clk)
    prev_d <= d;

reg rising_edge;
reg falling_edge;

always @(posedge clk or negedge clk)
begin
    rising_edge <= (clk == 1'b1) && (prev_clk == 1'b0);
    falling_edge <= (clk == 1'b0) && (prev_clk == 1'b1);
end

always @(posedge clk)
    if (rising_edge || falling_edge)
        q <= (rising_edge) ? d : prev_d;

endmodule