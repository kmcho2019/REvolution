module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] curr_in;  // register to store the current input signal
reg [7:0] prev_in;  // register to store the previous input signal
reg [7:0] pedge_reg;  // register to store the edge detection output

always @(posedge clk) begin
    curr_in <= in;  // capture the current input signal
    prev_in <= curr_in;  // update the previous input signal
    pedge_reg <= (curr_in & ~prev_in);  // detect positive edge transition
    pedge <= pedge_reg;  // generate the final output
end

endmodule