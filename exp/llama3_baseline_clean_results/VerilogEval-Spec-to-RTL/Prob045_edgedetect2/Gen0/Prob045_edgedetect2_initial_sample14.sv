module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // register to store previous value of input vector

always @(posedge clk) begin
    anyedge <= prev_in ^ in; // detect any edge by XORing current and previous values
    prev_in <= in; // update previous value on each clock cycle
end

endmodule