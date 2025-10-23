module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

// Register to store the positive edge detection output
reg [7:0] pedge_reg;
reg [7:0] prev_in;

// Always block to update the previous input and detect positive edges
always @(posedge clk) begin
    // Update the previous input state
    prev_in <= in;
    
    // Detect positive edges by checking for a transition from 0 to 1
    // and update the output register accordingly
    pedge_reg <= in & (~prev_in);
end

// Assign the output of the positive edge detection to the module output
assign pedge = pedge_reg;

endmodule