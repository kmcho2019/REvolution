module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // store previous input value

always @(posedge clk) begin
    prev_in <= in; // update previous input value on each clock cycle
end

assign anyedge = in ^ prev_in; // detect edge using XOR operation

endmodule