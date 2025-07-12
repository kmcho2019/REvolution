module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] counter_reg;
wire [9:0] next_counter;

// Combinational next state logic
assign next_counter = reset ? 10'd0 : 
                     (counter_reg == 10'd999) ? 10'd0 : 
                     counter_reg + 1'b1;

// Sequential state register
always @(posedge clk)
    counter_reg <= next_counter;

// Output assignment
assign q = counter_reg;

endmodule