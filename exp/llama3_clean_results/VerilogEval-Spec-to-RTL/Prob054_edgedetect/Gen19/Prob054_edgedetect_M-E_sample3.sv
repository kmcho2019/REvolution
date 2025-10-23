module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous input values

always @(posedge clk) begin
    prev_in <= in;  // update the previous input values
end

always @(*) begin
    pedge = in & ~prev_in;  // detect positive edges
end

endmodule