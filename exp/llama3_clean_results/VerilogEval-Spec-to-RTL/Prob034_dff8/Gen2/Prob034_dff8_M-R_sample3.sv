module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q // Declare q as reg
);

always @(posedge clk) begin
    q <= d; // Non-blocking assignment to update q at the positive edge of clk
end

endmodule