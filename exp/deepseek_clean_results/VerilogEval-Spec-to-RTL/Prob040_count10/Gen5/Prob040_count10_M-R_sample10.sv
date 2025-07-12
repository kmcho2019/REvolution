module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count_reg;
wire [3:0] next_count;

// Combinational logic for next state
assign next_count = reset ? 4'b0000 : 
                   (count_reg[3] & count_reg[0]) ? 4'b0000 : 
                   count_reg + 1'b1;

// Sequential logic for state storage
always @(posedge clk) begin
    count_reg <= next_count;
end

// Output assignment
assign q = count_reg;

endmodule