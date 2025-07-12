module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    prev_in <= in;
end

always @(posedge clk) begin
    pedge <= (in & ~(prev_in));
end

initial begin
    prev_in = 8'd0;
end

endmodule