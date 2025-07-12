module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // Register to store the previous state of the input
reg [7:0] pedge_reg;  // Register to store the detected edges

always @(posedge clk) begin
    prev_in <= in;  // Update the previous state at each clock cycle
    pedge_reg <= (in & ~prev_in);  // Detect the positive edge
end

assign pedge = pedge_reg;  // Assign the detected edges to the output

endmodule