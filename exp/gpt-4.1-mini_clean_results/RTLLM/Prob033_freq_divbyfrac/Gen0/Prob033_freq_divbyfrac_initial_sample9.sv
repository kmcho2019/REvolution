module freq_divbyfrac(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division by 3.5
    localparam integer MUL2_DIV_CLK = 7; // 3.5 * 2 = 7
    localparam integer HIGH_COUNT = 4;   // high phase length in input clk cycles
    localparam integer LOW_COUNT  = 3;   // low phase length in input clk cycles

    // Counter for rising edge domain
    reg [2:0] cnt_r = 0;
    reg clk_div_r = 0;

    // Counter for falling edge domain
    reg [2:0] cnt_f = 0;
    reg clk_div_f = 0;

    // Rising edge clock domain: generate one phase of divided clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_r <= 0;
            clk_div_r <= 0;
        end else begin
            if (clk_div_r == 0) begin
                // In low phase: count LOW_COUNT cycles
                if (cnt_r == LOW_COUNT - 1) begin
                    cnt_r <= 0;
                    clk_div_r <= 1;  // switch to high phase
                end else begin
                    cnt_r <= cnt_r + 1;
                end
            end else begin
                // In high phase: count HIGH_COUNT cycles
                if (cnt_r == HIGH_COUNT - 1) begin
                    cnt_r <= 0;
                    clk_div_r <= 0;  // switch to low phase
                end else begin
                    cnt_r <= cnt_r + 1;
                end
            end
        end
    end

    // Falling edge clock domain: generate the complementary phase-shifted divided clock
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_f <= 0;
            clk_div_f <= 0;
        end else begin
            if (clk_div_f == 0) begin
                // In low phase: count HIGH_COUNT cycles (opposite phase to clk_div_r)
                if (cnt_f == HIGH_COUNT - 1) begin
                    cnt_f <= 0;
                    clk_div_f <= 1;
                end else begin
                    cnt_f <= cnt_f + 1;
                end
            end else begin
                // In high phase: count LOW_COUNT cycles
                if (cnt_f == LOW_COUNT - 1) begin
                    cnt_f <= 0;
                    clk_div_f <= 0;
                end else begin
                    cnt_f <= cnt_f + 1;
                end
            end
        end
    end

    // Final output is OR of two phase-shifted divided clocks for uniform duty cycle
    assign clk_div = clk_div_r | clk_div_f;

endmodule