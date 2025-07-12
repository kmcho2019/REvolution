module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous input
reg [7:0] pedge_reg; // Register to store the output

always @(posedge clk) begin
    prev_in <= in; // Store the current input as the previous input
    pedge_reg <= (in & ~prev_in); // Set the output if a 0 to 1 transition is detected
end

assign pedge = pedge_reg; // Assign the output register to the output port

endmodule