module TopModule(
    input clk,
    input d,
    output reg q = 0 // Initialize output to 0 for simulation and synthesis purposes
);

always @(posedge clk) begin
    q <= d; // Non-blocking assignment for sequential logic synthesis
end

endmodule