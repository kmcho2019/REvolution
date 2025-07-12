module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] counter_reg;
wire [9:0] next_counter;

// Terminal count detection
wire terminal_count = (counter_reg == 10'd999);

// Next state calculation
assign next_counter = reset ? 10'd0 : 
                     terminal_count ? 10'd0 : 
                     counter_reg + 1'b1;

// Register update
always @(posedge clk) begin
    counter_reg <= next_counter;
end

// Output assignment
assign q = counter_reg;

endmodule