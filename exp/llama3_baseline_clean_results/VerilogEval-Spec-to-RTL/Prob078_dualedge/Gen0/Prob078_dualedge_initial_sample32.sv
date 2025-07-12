module TopModule(
    input clk,
    input d,
    output q
);

reg q_reg;

// Create a pulse on both edges of the clock
reg clk_pulse;
always @(posedge clk or negedge clk) begin
    clk_pulse <= 1'b1;
end
always @(posedge clk) begin
    clk_pulse <= 1'b0;
end

// Use the pulse to capture the data
always @(posedge clk_pulse) begin
    q_reg <= d;
end

assign q = q_reg;

endmodule