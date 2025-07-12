module TopModule (
    input clk,
    input d,
    output reg q
);

wire d_in;
assign d_in = d;

always @(posedge clk) begin
    q <= d_in;
end

endmodule