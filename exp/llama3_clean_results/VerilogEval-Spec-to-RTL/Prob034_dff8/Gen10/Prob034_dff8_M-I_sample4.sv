// Improved TopModule with simplified assignment
module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q = 8'b0 // Initialize q with zeros
);

always @(posedge clk) begin
    q <= d; // Simplified assignment
end

endmodule