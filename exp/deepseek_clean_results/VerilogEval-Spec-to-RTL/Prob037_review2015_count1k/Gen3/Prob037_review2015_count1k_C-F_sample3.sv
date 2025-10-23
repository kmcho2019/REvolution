module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] counter_reg;
wire counter_enable;

// Clock gating: only enable counter when not at max value or reset
assign counter_enable = (counter_reg != 10'd999) || reset;

// Sequential block with synchronous reset and enable
always @(posedge clk) begin
    if (reset) begin
        counter_reg <= 10'b0;
    end
    else if (counter_enable) begin
        counter_reg <= counter_reg + 1'b1;  // Natural overflow at 1000
    end
end

assign q = counter_reg;

endmodule