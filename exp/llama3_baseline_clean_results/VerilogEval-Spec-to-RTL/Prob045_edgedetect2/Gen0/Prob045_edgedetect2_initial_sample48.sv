module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // Register to hold the previous input value
reg [7:0] anyedge; // Output register to hold the edge detection result

always @(posedge clk) begin
    prev_in <= in; // On each clock cycle, store the current input as the previous input
end

always @(posedge clk) begin
    // Compare the current input with the previous input to detect any edge
    anyedge <= (in !== prev_in); 
end

endmodule