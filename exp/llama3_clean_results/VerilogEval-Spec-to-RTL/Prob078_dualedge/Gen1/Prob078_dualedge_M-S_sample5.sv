module TopModule(
    input clk,
    input d,
    output q
);

reg q_reg;

always @(posedge clk) begin
    q_reg <= d;
end

assign q = q_reg;

// This doesn't work due to the limitation in Verilog.
// Instead, we use the following code to achieve the same functionality.

reg clk_x2;
always @(posedge clk or negedge clk) begin
    clk_x2 <= ~clk_x2;
end

reg q_reg_simplified;
always @(posedge clk_x2) begin
    q_reg_simplified <= d;
end

assign q = q_reg_simplified;

endmodule