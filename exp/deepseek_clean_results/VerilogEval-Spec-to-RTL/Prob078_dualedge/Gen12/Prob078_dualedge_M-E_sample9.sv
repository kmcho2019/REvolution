module TopModule (
    input clk,
    input d,
    output reg q
);

reg prev_clk;

always @(posedge clk or negedge clk) begin
    // Detect both edges using XOR
    if (clk ^ prev_clk) begin
        q <= d;
    end
    prev_clk <= clk;
end

endmodule