module TopModule (
    input clk,
    input d,
    output q
);

// Generate 90° phase-shifted clock
reg clk_90;
always @(posedge clk) begin
    clk_90 <= ~clk_90;
end

// Sample data on original clock (0° phase)
reg sample_0;
always @(posedge clk) begin
    sample_0 <= d;
end

// Sample data on 90° phase-shifted clock
reg sample_90;
always @(posedge clk_90) begin
    sample_90 <= d;
end

// Combine samples to create dual-edge behavior
reg q_reg;
always @(*) begin
    if (clk ^ clk_90) begin  // When clocks are in transition
        q_reg = sample_90;
    end else begin
        q_reg = sample_0;
    end
end

assign q = q_reg;

endmodule