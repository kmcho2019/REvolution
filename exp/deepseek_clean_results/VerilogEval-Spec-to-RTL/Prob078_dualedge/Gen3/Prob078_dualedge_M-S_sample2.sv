module TopModule (
    input clk,
    input d,
    output reg q
);

reg prev_clk;

always @(clk) begin
    if (clk ^ prev_clk) begin  // Detect any clock edge
        q <= d;
    end
    prev_clk <= clk;
end

endmodule