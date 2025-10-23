module TopModule(
    input clk,
    input in,
    output reg out
);

// Initialize 'out' to avoid unknown value during simulation
initial out = 1'b0;

// Update 'out' based on 'in' and current 'out' at the positive edge of 'clk'
always @(posedge clk) begin
    out <= (out == 1'b0) ? in : ~in;
end

endmodule