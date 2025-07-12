module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // Register to store the previous state of the input signal
reg [7:0] pedge_reg;  // Register to store the result of the edge detection

always @(posedge clk) begin
    prev_in <= in;  // Update the previous state of the input signal
    for (int i = 0; i < 8; i++) begin
        if (prev_in[i] == 0 && in[i] == 1) begin
            pedge_reg[i] <= 1;  // Set the output bit to 1 if a positive edge is detected
        end else begin
            pedge_reg[i] <= 0;  // Reset the output bit if no positive edge is detected
        end
    end
end

assign pedge = pedge_reg;  // Assign the output register to the output port

endmodule