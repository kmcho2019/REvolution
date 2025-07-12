module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous state of the input vector
reg [7:0] pedge_reg; // Register to store the output

always @ (posedge clk) begin
    // Detect positive edge transitions
    pedge_reg <= ~prev_in & in;
    
    // Update the previous state register
    prev_in <= in;
end

assign pedge = pedge_reg; // Assign the output register to the output port

endmodule