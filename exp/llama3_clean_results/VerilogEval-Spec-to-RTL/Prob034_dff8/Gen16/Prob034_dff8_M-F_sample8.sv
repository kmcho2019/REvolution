// Revised TopModule with 8 D flip-flops
module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Initialize q to a known state to avoid latch inference
initial q = 8'b0;

// Use a non-blocking assignment to capture the input d at the positive edge of clk
always @(posedge clk) begin
    q <= d;
end

endmodule