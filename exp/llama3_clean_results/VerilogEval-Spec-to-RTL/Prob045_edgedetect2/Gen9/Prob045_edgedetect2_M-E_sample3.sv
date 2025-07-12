// TopModule: Detects any edge transitions in the 8-bit input signal 'in'
// and outputs a corresponding 8-bit signal 'anyedge' where each bit is set
// to 1 if the corresponding bit in 'in' has changed from the previous clock cycle.

module TopModule(
    input clk,         // Clock signal
    input [7:0] in,   // 8-bit input signal
    output reg [7:0] anyedge // 8-bit output signal indicating edge transitions
);

reg [7:0] prev_in;    // Register to store the previous value of 'in'
reg [7:0] edge_det;   // Register to store the edge detection result

// Always block triggered on the positive edge of the clock
always @(posedge clk) begin
    // Update 'prev_in' with the current value of 'in'
    prev_in <= in;
    
    // Initialize 'edge_det' to 0
    edge_det = 0;
    
    // Iterate through each bit of the input signal
    for (int i = 0; i < 8; i++) begin
        // Check for edge transition on the current bit
        if (in[i] !== prev_in[i]) begin
            // Set the corresponding bit in 'edge_det' to 1 if an edge transition is detected
            edge_det[i] = 1;
        end
    end
    
    // Assign the edge detection result to 'anyedge'
    anyedge <= edge_det;
end

endmodule