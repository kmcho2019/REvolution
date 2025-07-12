module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous state of the input signal
reg [7:0] pedge_reg;  // register to store the positive edge detection result

always @(posedge clk) begin
    prev_in <= in;  // update the previous state
    for (int i = 0; i < 8; i++) begin
        pedge_reg[i] <= in[i] && !prev_in[i];  // detect 0 to 1 transition
    end
end

assign pedge = pedge_reg;  // assign the positive edge detection result to the output

endmodule