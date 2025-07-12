module up_down_counter #(
    parameter WIDTH = 16
) (
    input clk,
    input reset,
    input enable,    // Added for power optimization
    input up_down,
    output [WIDTH-1:0] count
);

reg [WIDTH-1:0] count_reg;

assign count = count_reg;

always @(posedge clk) begin
    if (reset) begin
        count_reg <= {WIDTH{1'b0}};
    end else if (enable) begin
        count_reg <= up_down ? count_reg + 1'b1 : count_reg - 1'b1;
    end
end

endmodule