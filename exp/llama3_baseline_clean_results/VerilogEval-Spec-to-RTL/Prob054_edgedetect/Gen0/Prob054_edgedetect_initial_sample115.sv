module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_state;

always @(posedge clk) begin
    pedge <= prev_state & ~in;
    prev_state <= in;
end

initial begin
    prev_state <= 8'b0;
end

endmodule