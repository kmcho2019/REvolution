module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_clk;

always @(posedge clk or negedge clk) begin
    prev_clk <= clk;
    if (clk != prev_clk) begin // This condition is true on both edges
        q <= d;
    end
end

endmodule