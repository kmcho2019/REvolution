module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge // Declare pedge as reg type
);

reg [7:0] prev_in; // Register to store the previous state of 'in'
reg [7:0] edge_detected; // Register to store the detected edges

always @(posedge clk) begin
    prev_in <= in; // Update the previous state on every clock cycle
    // Capture the transitions and set edge_detected
    for (int i = 0; i < 8; i++) begin
        if (in[i] == 1 && prev_in[i] == 0) begin
            edge_detected[i] <= 1; // Set the edge_detected bit to '1' if positive edge detected
        end else begin
            edge_detected[i] <= 0; // Otherwise, set the edge_detected bit to '0'
        end
    end
    // Set the output pedge based on the previously detected edges
    pedge <= edge_detected;
end

endmodule