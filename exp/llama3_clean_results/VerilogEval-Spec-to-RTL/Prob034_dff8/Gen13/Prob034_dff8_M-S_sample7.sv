// Define the TopModule that includes 8 D flip-flops
module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Implement 8 D flip-flops using a single always block
always @(posedge clk) begin
    q <= d; // Update q with d at the positive edge of clk
end

endmodule