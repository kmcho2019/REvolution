module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous state of the input vector
reg [7:0] pedge_reg; // Register to store the output

always @(posedge clk) begin
    prev_in <= in; // Update the previous state on every clock cycle
    pedge_reg <= (in & (~prev_in)); // Detect rising edges and set the output
end

assign pedge = pedge_reg; // Assign the output register to the output port

initial begin
    prev_in = 8'b0; // Initialize the previous state to zero
    pedge_reg = 8'b0; // Initialize the output register to zero
end

endmodule