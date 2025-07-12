module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // shift register to store the previous state of the input vector

always @(posedge clk) begin
    prev_in <= in;  // update the previous state
    pedge <= (in & ~(prev_in)) & (in ^ prev_in);  // detect 0 to 1 transitions using bitwise operations
end

endmodule