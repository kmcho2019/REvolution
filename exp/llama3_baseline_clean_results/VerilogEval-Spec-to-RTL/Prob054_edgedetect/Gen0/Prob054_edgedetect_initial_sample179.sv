module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // Register to store the previous state of each bit
reg [7:0] pedge_reg;  // Register to store the output

always @(posedge clk) begin
    prev_in <= in;  // Update the previous state register on each clock cycle
    pedge_reg <= (in & (~prev_in));  // Detect the positive edge transition
    pedge <= pedge_reg;  // Update the output
end

endmodule