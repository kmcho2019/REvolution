module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg = 8'h34; // Initialize output register with 0x34

always @(negedge clk or posedge reset) begin
    if (reset) begin
        q_reg <= 8'h34; // Reset to 0x34 on active high reset
    end else begin
        q_reg <= d; // Load input d on negative edge of clk
    end
end

assign q = q_reg; // Continuous assignment to output

endmodule