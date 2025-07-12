module TopModule(
    input  logic clk,
    input  logic d,
    input  logic r,
    output logic q
);

// Using a synchronous reset with a ternary operator for concise expression
always @(posedge clk) begin
    q <= r ? 1'b0 : d; // Reset output to 0 when r is high, otherwise load input data
end

endmodule