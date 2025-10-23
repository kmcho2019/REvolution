module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Single always block for all 8 positive-edge triggered D flip-flops
always @(posedge clk) begin
    q <= d;
end

// Initialize all flip-flops to zero for simulation
initial begin
    q = 8'b0;
end

endmodule