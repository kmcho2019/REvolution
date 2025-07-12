module TopModule (
    input clk,
    input d,
    output q
);

reg q_reg;

always @(posedge clk) begin
    q_reg <= d;
end

assign #1 q = q_reg;  // Adding small delay to model clock-to-Q delay

endmodule