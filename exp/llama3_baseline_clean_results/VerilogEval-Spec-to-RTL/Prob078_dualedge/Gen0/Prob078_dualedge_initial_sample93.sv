module TopModule(
    input clk,
    input d,
    output reg q
);

reg previous_clk;

always @(posedge clk or negedge clk) begin
    if (clk !== previous_clk) begin
        previous_clk <= clk;
        q <= d;
    end
end

endmodule