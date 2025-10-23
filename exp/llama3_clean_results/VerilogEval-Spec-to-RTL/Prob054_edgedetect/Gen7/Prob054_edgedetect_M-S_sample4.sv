module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge = 0
);

reg [7:0] prev_in; // register to store the previous value of in

always @(posedge clk) begin
    prev_in <= in; // update the previous value on every clock cycle
    pedge <= (in & (~prev_in)); // directly detect positive edge transitions
end

endmodule