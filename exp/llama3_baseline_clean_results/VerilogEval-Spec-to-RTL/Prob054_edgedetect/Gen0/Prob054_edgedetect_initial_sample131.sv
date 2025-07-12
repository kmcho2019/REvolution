module TopModule(
    input           clk,
    input   [7:0]   in,
    output  [7:0]   pedge
);

reg [7:0] prev_in;  // Register to store the previous state of 'in'
reg [7:0] pedge_reg;  // Register to store the output 'pedge'

always @(posedge clk) begin
    prev_in <= in;  // Update the previous state at each clock cycle
    pedge_reg <= (prev_in == 0) & in;  // Detect 0 to 1 transitions
end

assign pedge = pedge_reg;  // Assign the output

endmodule