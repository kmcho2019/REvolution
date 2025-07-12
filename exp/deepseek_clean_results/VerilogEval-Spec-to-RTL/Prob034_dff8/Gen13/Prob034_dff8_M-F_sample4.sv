module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Single always block for all 8 D flip-flops with clock-to-q delay
always @(posedge clk) begin
    q <= #1 d;  // Small delay to ensure output stability
end

endmodule