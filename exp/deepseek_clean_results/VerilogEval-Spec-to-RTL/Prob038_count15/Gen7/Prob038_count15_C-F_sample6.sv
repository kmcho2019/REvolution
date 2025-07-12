module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg clk_enable;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
        clk_enable <= 1'b1;
    end
    else if (clk_enable) begin
        q <= q + 1'b1;
        if (q == 4'b1111) begin
            clk_enable <= 1'b0;
        end
    end
end

endmodule