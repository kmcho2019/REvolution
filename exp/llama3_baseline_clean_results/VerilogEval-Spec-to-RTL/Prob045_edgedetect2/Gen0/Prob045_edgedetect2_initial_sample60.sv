module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // Register to store the previous state of the input
reg [7:0] anyedge_reg; // Register to store the output

always @(posedge clk) begin
    prev_in <= in; // Update the previous state on each positive edge of the clock
    anyedge_reg <= (in ^ prev_in); // Detect any edge by XORing current and previous states
end

assign anyedge = anyedge_reg; // Assign the output of the register to the output port

endmodule