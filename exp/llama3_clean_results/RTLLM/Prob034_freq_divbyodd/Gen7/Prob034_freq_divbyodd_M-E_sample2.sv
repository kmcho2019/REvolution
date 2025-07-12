module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt;  // Counter for clock cycles
reg        pwm_sig;  // PWM signal
reg        clk_div_int;  // Internal divided clock

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        pwm_sig <= 1'b0;
        clk_div_int <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV - 1)) begin
            cnt <= cnt + 1;
            pwm_sig <= (cnt < (NUM_DIV / 2)) ? 1'b1 : 1'b0;
        end else begin
            cnt <= 0;
            pwm_sig <= 1'b0;
            clk_div_int <= ~clk_div_int;
        end
    end
end

assign clk_div = clk_div_int;

endmodule