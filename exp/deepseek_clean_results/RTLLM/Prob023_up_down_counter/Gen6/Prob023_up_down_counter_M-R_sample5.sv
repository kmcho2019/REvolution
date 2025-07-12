module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output [15:0] count
);

reg [15:0] count_reg;

// Sequential logic with direct calculation
always @(posedge clk) begin
    if (reset)
        count_reg <= 16'b0;
    else if (up_down)
        count_reg <= count_reg + 1'b1;
    else
        count_reg <= count_reg - 1'b1;
end

// Continuous output assignment
assign count = count_reg;

endmodule