module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous state of the input vector
reg [7:0] pedge_reg; // Register to store the output

always @(posedge clk) begin
    prev_in <= in; // Update the previous state at every clock edge
    pedge_reg <= (in & (~prev_in)); // Detect positive edge and update output
end

assign pedge = pedge_reg; // Assign the output to the output port

endmodule