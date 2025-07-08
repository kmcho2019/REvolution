module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Generate 8 D flip-flops
always @(posedge clk) begin
    q <= d;
end

endmodule