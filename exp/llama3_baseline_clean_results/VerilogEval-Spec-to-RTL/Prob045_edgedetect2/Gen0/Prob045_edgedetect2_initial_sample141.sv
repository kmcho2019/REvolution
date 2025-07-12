module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // register to store previous state of input vector

always @(posedge clk) begin
    anyedge <= in ^ prev_in; // detect any edge by XORing current and previous states
    prev_in <= in; // update previous state for next clock cycle
end

endmodule