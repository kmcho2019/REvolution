module TopModule (
    input clk,
    input d,
    output q
);

// Generate phase-shifted clocks (simplified for conceptual implementation)
wire clk_90, clk_270;
reg [1:0] phase_counter = 0;

always @(posedge clk) begin
    phase_counter <= phase_counter + 1;
end

assign clk_90 = phase_counter[0];
assign clk_270 = phase_counter[1];

// Sampling registers
reg sample_90, sample_270;

always @(posedge clk_90) begin
    sample_90 <= d;
end

always @(posedge clk_270) begin
    sample_270 <= d;
end

// Output logic
assign q = (clk & ~clk_90) ? sample_90 : 
           (~clk & clk_270) ? sample_270 : 
           q;

endmodule