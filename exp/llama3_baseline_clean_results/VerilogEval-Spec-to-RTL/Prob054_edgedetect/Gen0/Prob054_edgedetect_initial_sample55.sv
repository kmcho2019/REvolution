module TopModule(
    input  clk,
    input  [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous state of the input vector
reg [7:0] pedge_reg; // Register to store the pedge output

always @ (posedge clk) begin
    prev_in <= in; // Update the previous state on each clock cycle
    pedge_reg <= (in & ~prev_in); // Detect rising edges
end

assign pedge = pedge_reg; // Continuous assignment to output

endmodule