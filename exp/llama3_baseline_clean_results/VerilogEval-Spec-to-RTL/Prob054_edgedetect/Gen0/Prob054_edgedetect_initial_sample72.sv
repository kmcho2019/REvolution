module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_state;
reg [7:0] pedge;

always @(posedge clk) begin
    prev_state <= in;
    pedge <= (in & (~prev_state)); // set pedge bit if in is 1 and prev_state is 0
end

endmodule