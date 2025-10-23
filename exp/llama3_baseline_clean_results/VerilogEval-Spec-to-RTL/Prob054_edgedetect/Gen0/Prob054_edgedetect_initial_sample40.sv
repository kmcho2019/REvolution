module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store previous input
reg [7:0] pedge_reg; // Register to store output

always @(posedge clk) begin
    // Detect positive edge transitions
    pedge_reg <= (in & ~(prev_in));
    
    // Update previous input
    prev_in <= in;
end

// Assign output to registered value
assign pedge = pedge_reg;

endmodule