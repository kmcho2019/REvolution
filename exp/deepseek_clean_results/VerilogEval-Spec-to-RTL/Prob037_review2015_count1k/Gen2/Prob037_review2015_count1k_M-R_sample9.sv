module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] counter_reg;
wire [9:0] next_count;

// Combinational next state logic
assign next_count = (reset) ? 10'b0 : 
                   (counter_reg == 10'd999) ? 10'b0 : 
                   counter_reg + 1'b1;

// Sequential state update
always @(posedge clk) begin
    counter_reg <= next_count;
end

// Output assignment
assign q = counter_reg;

endmodule