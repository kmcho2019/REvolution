module TopModule (
    input clk,
    input d,
    output q
);

reg clk2x = 0;
reg q_reg;

// Generate 2x clock (phase-aligned with original clock)
always @(posedge clk) begin
    clk2x <= ~clk2x;
end

// Sample on every rising edge of 2x clock
always @(posedge clk2x) begin
    q_reg <= d;
end

assign q = q_reg;

endmodule