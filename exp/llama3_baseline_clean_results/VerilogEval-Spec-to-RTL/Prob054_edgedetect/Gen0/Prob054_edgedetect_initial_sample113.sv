module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    pedge <= (in & (~prev_in)); // set pedge bit to 1 if in bit changed from 0 to 1
    prev_in <= in; // update previous state
end

endmodule