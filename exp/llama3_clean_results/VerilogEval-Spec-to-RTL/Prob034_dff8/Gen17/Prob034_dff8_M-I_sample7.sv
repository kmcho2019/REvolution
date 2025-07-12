// Improved TopModule with 8 D flip-flops
module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Initialize q to a known state to avoid latch inference
initial q = 8'b0;

always @(posedge clk) begin
    // Explicitly capture the input d at the positive edge of clk and assign to q
    // Using non-blocking assignment for clarity and adherence to best practices
    q <= d;
end

endmodule