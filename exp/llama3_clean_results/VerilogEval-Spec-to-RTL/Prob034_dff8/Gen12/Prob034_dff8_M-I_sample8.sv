module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg; // Internal register for q

always @(posedge clk) begin
    q_reg <= d; // Non-blocking assignment to avoid race conditions
end

assign q = q_reg; // Continuous assignment to output q

endmodule