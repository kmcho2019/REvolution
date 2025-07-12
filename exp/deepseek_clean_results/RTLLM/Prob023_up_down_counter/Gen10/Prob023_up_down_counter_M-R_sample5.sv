module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output [15:0] count
);

reg [15:0] count_reg;
wire [15:0] next_count;

// Next state logic
assign next_count = reset ? 16'b0 : 
                   up_down ? count_reg + 1'b1 : 
                   count_reg - 1'b1;

// State update
always @(posedge clk) begin
    count_reg <= next_count;
end

// Output assignment
assign count = count_reg;

endmodule