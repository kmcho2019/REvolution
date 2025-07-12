module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous state of the input signal
reg [7:0] pedge_reg;  // register to store the positive edge detection output

always @(posedge clk) begin
    prev_in <= in;  // update the previous state
    for (int i = 0; i < 8; i++) begin
        // Detect positive edges by checking for a transition from 0 to 1
        // and update the output register accordingly
        pedge_reg[i] <= in[i] & (~prev_in[i]);
    end
    pedge <= pedge_reg;  // assign the output of the positive edge detection to the module output
end

endmodule