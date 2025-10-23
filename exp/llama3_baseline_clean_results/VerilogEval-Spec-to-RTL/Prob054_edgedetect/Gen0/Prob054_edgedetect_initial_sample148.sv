module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in; // register to store previous state of input signal

always @(posedge clk) begin
    prev_in <= in; // store current input signal at each clock cycle
    pedge <= (in & (~prev_in)); // detect rising edge and set output bit
end

endmodule