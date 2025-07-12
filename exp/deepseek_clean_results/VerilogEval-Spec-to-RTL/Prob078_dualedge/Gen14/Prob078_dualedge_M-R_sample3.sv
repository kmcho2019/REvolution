module TopModule (
    input clk,
    input d,
    output reg q
);

    reg prev_clk;
    wire pos_edge = ~prev_clk & clk;
    wire neg_edge = prev_clk & ~clk;

    always @(*) begin
        if (pos_edge || neg_edge) begin
            q <= d;
        end
        prev_clk <= clk;
    end

endmodule