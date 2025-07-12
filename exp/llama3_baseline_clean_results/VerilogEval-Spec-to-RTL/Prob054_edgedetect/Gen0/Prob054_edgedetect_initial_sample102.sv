module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // register to store previous input vector
reg [7:0] pedge;   // output register

always @(posedge clk) begin
    // detect 0 to 1 transitions
    pedge <= (in & (~prev_in));
    // update previous input vector
    prev_in <= in;
end

endmodule