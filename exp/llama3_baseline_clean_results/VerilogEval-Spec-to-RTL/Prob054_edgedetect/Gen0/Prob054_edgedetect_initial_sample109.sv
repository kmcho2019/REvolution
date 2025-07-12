module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // Register to store the previous state of the input vector
reg [7:0] pedge_reg;  // Register to store the output

always @(*) begin
    for (int i = 0; i < 8; i++) begin
        pedge_reg[i] = prev_in[i] == 0 && in[i] == 1;  // Check for 0 to 1 transition
    end
end

always @(posedge clk) begin
    prev_in <= in;  // Update the previous state on the rising edge of the clock
    pedge <= pedge_reg;  // Update the output
end

endmodule