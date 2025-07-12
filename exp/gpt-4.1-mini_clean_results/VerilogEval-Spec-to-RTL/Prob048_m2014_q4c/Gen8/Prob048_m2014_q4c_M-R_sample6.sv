module TopModule (
    input  wire clk,
    input  wire d,
    input  wire r,
    output reg  q
);

always @(posedge clk) begin
    q <= r ? 1'b0 : d;
end

endmodule