module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;  // register to store previous state of input bits
reg [7:0] anyedge;  // register to store output bits

always @ (posedge clk) begin
    prev_in <= in;  // update previous state on each clock cycle
    anyedge <= in ^ prev_in;  // detect edge and update output
end

endmodule