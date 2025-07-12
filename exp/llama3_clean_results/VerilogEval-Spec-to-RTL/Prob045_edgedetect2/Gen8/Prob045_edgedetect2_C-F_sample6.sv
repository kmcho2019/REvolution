// TopModule: Detects any edge transitions in the 8-bit input signal 'in'
// and outputs a corresponding 8-bit signal 'anyedge' where each bit is set
// to 1 if the corresponding bit in 'in' has changed from the previous clock cycle.

module TopModule(
    input clk,         // Clock signal
    input [7:0] in,   // 8-bit input signal
    output reg [7:0] anyedge // 8-bit output signal indicating edge transitions
);

reg [7:0] prev_in;    // Register to store the previous value of 'in'

// Always block triggered on the positive edge of the clock
always @(posedge clk) begin
    // Update 'prev_in' with the current value of 'in'
    prev_in <= in;
    
    // Calculate 'anyedge' by performing a bitwise XOR between 'in' and 'prev_in'
    // This will set a bit in 'anyedge' to 1 if the corresponding bit in 'in' has changed
    anyedge <= in ^ prev_in;
end

endmodule