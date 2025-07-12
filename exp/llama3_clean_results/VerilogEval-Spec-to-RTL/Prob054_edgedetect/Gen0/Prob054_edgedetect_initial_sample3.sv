module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous state of 'in'

always @(posedge clk) begin
    prev_in <= in; // Update the previous state on every clock cycle
end

always @(*) begin
    for (int i = 0; i < 8; i++) begin
        // Check for positive edge detection
        if (in[i] == 1 && prev_in[i] == 0) begin
            pedge[i] = 1; // Set the output bit to '1' if positive edge detected
        end else begin
            pedge[i] = 0; // Otherwise, set the output bit to '0'
        end
    end
end

endmodule