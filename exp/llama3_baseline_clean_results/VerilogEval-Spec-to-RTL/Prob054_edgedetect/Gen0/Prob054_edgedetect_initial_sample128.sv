module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;

initial begin
    prev_in = 8'b0;
end

always @(posedge clk) begin
    pedge <= (in & (~prev_in));
    prev_in <= in;
end

endmodule