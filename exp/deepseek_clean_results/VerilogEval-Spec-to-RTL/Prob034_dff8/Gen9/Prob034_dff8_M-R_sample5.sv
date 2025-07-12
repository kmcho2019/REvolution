module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg = 8'b0;  // Vector register with initialization

always @(posedge clk) begin
    q_reg <= d;          // Parallel update of all bits
end

assign q = q_reg;        // Continuous output assignment

endmodule