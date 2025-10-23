module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] count;

always @(posedge clk) begin
    count <= reset ? 10'd0 : (count + 10'd1);
end

assign q = count;

endmodule