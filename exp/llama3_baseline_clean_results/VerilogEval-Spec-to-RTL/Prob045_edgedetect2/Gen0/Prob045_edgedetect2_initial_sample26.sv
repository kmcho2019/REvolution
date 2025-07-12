module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // Register to store the previous state of the input vector

always @(posedge clk) begin
    anyedge <= (in ^ prev_in); // Set anyedge to the XOR of the current input and the previous input
    prev_in <= in; // Update the previous input on every positive edge of the clock
end

endmodule