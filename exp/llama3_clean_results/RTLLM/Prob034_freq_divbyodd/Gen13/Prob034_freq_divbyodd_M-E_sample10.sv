module freq_divbyodd #(
    parameter NUM_DIV = 5,  // Odd divisor
    parameter N = 16       // Number of bits for phase accumulator
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [N-1:0] phase_accum;  // Phase accumulator
reg        clk_div_int;   // Internal divided clock

// Calculate the increment value based on NUM_DIV
localparam increment = (1 << N) / NUM_DIV;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        phase_accum <= 0;
        clk_div_int <= 1'b0;
    end else begin
        if (phase_accum == (1 << N) - 1) begin
            phase_accum <= 0;
            clk_div_int <= ~clk_div_int;
        end else begin
            phase_accum <= phase_accum + increment;
        end
    end
end

assign clk_div = clk_div_int;

endmodule