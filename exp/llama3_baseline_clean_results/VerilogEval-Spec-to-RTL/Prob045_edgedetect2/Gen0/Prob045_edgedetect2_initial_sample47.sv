module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;  // Register to store the previous input
reg [7:0] anyedge_reg;  // Register to store the output

always @ (posedge clk) begin
    prev_in <= in;  // Update the previous input at the next clock cycle
    anyedge_reg <= (in ^ prev_in);  // Detect the edge and store the output
end

assign anyedge = anyedge_reg;  // Assign the output

endmodule