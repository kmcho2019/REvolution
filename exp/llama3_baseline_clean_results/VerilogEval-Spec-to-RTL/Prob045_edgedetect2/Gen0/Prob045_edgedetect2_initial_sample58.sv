module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // Register to store previous state of input vector
reg [7:0] anyedge; // Output register

always @(posedge clk) begin
    // Detect any edge by comparing current input with previous state
    anyedge <= (in != prev_in);
    
    // Update previous state register
    prev_in <= in;
end

endmodule