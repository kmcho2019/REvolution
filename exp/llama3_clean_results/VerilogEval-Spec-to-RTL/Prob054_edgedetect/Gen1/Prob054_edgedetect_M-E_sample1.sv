module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous state of 'in'
reg [7:0] temp_pedge; // Temporary register to delay the output

always @(posedge clk) begin
    prev_in <= in; // Update the previous state
    for (int i = 0; i < 8; i++) begin
        // Check for positive edge detection
        if (in[i] == 1 && prev_in[i] == 0) begin
            temp_pedge[i] <= 1; // Set the temporary output bit to '1' if positive edge detected
        end else begin
            temp_pedge[i] <= 0; // Otherwise, set the temporary output bit to '0'
        end
    end
    pedge <= temp_pedge; // Update the output in the next clock cycle
end

endmodule