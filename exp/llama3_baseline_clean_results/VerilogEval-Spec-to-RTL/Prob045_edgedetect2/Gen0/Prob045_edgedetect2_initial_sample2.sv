module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // register to store the previous input
reg [7:0] edge_detected; // register to store the detected edge

always @(posedge clk) begin
    // Store the current input for next cycle's comparison
    prev_in <= in;
    
    // Register the detected edge for output on the next cycle
    anyedge <= edge_detected;
end

always @(*) begin
    // Initialize edge_detected to all zeros
    edge_detected = 8'b0;
    
    // For each bit, check if there's a transition from previous to current
    for (int i = 0; i < 8; i++) begin
        if (in[i] !== prev_in[i]) begin
            // If there's a transition, mark the corresponding edge_detected bit
            edge_detected[i] = 1'b1;
        end
    end
end

endmodule