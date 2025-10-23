module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_state; // Register to store the previous state of in
reg [7:0] pedge; // Register to store the output

always @(posedge clk) begin
    prev_state <= in; // Update the previous state at every clock edge
    // Generate output
    for (int i = 0; i < 8; i++) begin
        if (prev_state[i] == 0 && in[i] == 1) begin
            pedge[i] <= 1'b1; // Set output bit to 1 on detecting positive edge
        end else begin
            pedge[i] <= 1'b0; // Reset output bit otherwise
        end
    end
end

endmodule