module TopModule (
    input wire clk,
    input wire d,
    output wire q
);

reg q_reg;

always @(posedge clk) begin : dff_behavior
    q_reg <= d;
end

assign q = q_reg;

endmodule