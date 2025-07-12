module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous input vector

always @(posedge clk) begin
    prev_in <= in;  // update the previous input vector
    pedge <= in & ~prev_in;  // detect 0 to 1 transitions using bitwise AND
end

endmodule