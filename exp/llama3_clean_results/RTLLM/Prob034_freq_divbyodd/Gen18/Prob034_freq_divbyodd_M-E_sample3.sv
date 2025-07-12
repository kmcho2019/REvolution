module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic [$clog2(NUM_DIV):0] phase_accum;
logic clk_div_int;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        phase_accum <= 0;
        clk_div_int <= 1'b0;
    end else begin
        phase_accum <= phase_accum + 1;
        if (phase_accum == (NUM_DIV - 1)) begin
            phase_accum <= 0;
            clk_div_int <= ~clk_div_int;
        end
    end
end

assign clk_div = clk_div_int;

endmodule