module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic [$clog2(NUM_DIV):0] cnt;
logic pwm_sig;
logic pwm_sig_dly;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        pwm_sig <= 1'b0;
        pwm_sig_dly <= 1'b0;
    end else begin
        cnt <= (cnt == (NUM_DIV - 1)) ? 0 : cnt + 1;
        pwm_sig <= (cnt < (NUM_DIV / 2)) ? 1'b1 : 1'b0;
        pwm_sig_dly <= pwm_sig;
    end
end

assign clk_div = pwm_sig | pwm_sig_dly;

endmodule