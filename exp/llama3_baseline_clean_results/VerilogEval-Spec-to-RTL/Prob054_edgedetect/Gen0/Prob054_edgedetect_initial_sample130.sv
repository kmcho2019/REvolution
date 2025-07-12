module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous value of 'in'
reg [7:0] pedge_reg; // Register to store the output of 'pedge'

always @(posedge clk) begin
    prev_in <= in; // Update the previous value of 'in' on each clock cycle
    pedge_reg <= (in & ~prev_in); // Detect rising edge and set the output
end

assign pedge = pedge_reg; // Assign the output of the register to the output port

endmodule