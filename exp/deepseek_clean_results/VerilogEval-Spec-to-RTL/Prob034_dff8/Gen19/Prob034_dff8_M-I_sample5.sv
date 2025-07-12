module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Single always block for all 8 flip-flops
always @(posedge clk) begin
    q <= d;
end

// Initialize all flip-flops to 0 (synthesis will ignore this)
initial begin
    q = 8'b0;
end

endmodule