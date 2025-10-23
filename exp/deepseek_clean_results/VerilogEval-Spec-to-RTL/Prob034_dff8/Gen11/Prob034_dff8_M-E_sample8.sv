module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

parameter WIDTH = 8;

always @(posedge clk) begin
    // Synchronous parallel load of all bits
    q <= d;
end

endmodule