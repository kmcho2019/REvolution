module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] phase_acc;  // Phase accumulator
reg        clk_div_int;  // Internal divided clock output

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        phase_acc <= 0;
        clk_div_int <= 1'b0;
    end else begin
        phase_acc <= phase_acc + (32'd1 << (32 - $clog2(NUM_DIV)));
        if (phase_acc >= (32'd1 << (32 - $clog2(NUM_DIV)) * (NUM_DIV / 2))) begin
            phase_acc <= 0;
            clk_div_int <= ~clk_div_int;
        end
    end
end

assign clk_div = clk_div_int;

endmodule