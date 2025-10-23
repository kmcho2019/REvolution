module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous state of the input signal
reg [7:0] pedge_reg;  // register to store the output signal

always @(posedge clk) begin
    prev_in <= in;  // update the previous state
    pedge_reg <= (in & (~prev_in));  // detect 0 to 1 transition using bitwise AND
    pedge <= pedge_reg;  // update the output signal
end

endmodule