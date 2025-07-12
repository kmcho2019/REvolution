module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in; // register to store the previous value of in

always @(posedge clk) begin
    pedge <= ~prev_in & in; // detect positive edge
    prev_in <= in; // update previous input
end

endmodule