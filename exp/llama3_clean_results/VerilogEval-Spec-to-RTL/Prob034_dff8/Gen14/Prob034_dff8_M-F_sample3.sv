module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q // Declare q as a reg type
);

always @(posedge clk) begin
    q <= d;
end

endmodule