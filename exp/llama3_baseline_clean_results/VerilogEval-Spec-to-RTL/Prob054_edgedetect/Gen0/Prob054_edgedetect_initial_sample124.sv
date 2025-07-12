module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;
reg [7:0] pedge;

always @(posedge clk) begin
    pedge <= (in & (~prev_in)); // check for 0 to 1 transition
    prev_in <= in; // update previous state
end

endmodule