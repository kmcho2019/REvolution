module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output [15:0] count
);

reg [15:0] count_reg;
wire [15:0] next_count;

// Combinational logic for next count value
assign next_count = up_down ? count_reg + 1'b1 : count_reg - 1'b1;

// Sequential logic for register update
always @(posedge clk) begin
    if (reset) begin
        count_reg <= 16'b0;
    end else begin
        count_reg <= next_count;
    end
end

// Continuous output assignment
assign count = count_reg;

endmodule