module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg = 8'b0; // Initialize q_reg to all zeros

always @(posedge clk) begin
    q_reg <= d; // Use non-blocking assignment for sequential logic
end

assign q = q_reg; // Continuously assign the value of q_reg to q

endmodule