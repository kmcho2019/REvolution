module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous state of 'in'
reg [7:0] temp_pedge; // Temporary register to store the detected edges

always @(posedge clk) begin
    // Capture the transitions and set temp_pedge
    for (int i = 0; i < 8; i++) begin
        if (in[i] == 1 && prev_in[i] == 0) begin
            temp_pedge[i] <= 1; // Set the temp_pedge bit to '1' if positive edge detected
        end else begin
            temp_pedge[i] <= 0; // Otherwise, set the temp_pedge bit to '0'
        end
    end
    // Update the previous state
    prev_in <= in; // Update prev_in after detecting edges, to hold the value of 'in' from the previous cycle
    // Set the output pedge based on the previously detected edges
    pedge <= temp_pedge;
end

endmodule