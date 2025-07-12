module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // 8-bit shift register to store the previous state

always @(posedge clk) begin
    // shift the contents of the shift register one bit to the right
    prev_in <= {in, prev_in[7:1]};
end

always @(*) begin
    // perform a bitwise XOR operation to detect positive edge transitions
    pedge <= in & (~prev_in);
end

endmodule