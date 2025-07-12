module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_clk;  // Previous state of the clock signal
reg q_reg;     // Output register

always @(posedge clk or negedge clk) begin
    if (clk != prev_clk) begin
        if (clk) begin
            // Positive edge
            q_reg <= d;
        end else begin
            // Negative edge
            q_reg <= d;
        end
    end
    prev_clk <= clk;
end

assign q = q_reg;

endmodule