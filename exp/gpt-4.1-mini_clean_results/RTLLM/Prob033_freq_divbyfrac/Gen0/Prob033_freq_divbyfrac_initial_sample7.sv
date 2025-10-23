module freq_divbyfrac(
    input  wire clk,      // Input clock
    input  wire rst_n,    // Active low reset
    output wire clk_div   // Fractionally divided clock output (divide by 3.5)
);

    // Parameters for 3.5 division
    localparam integer MUL2_DIV_CLK = 7;   // 3.5*2 = 7
    localparam integer HALF1 = 4;           // High count in one period
    localparam integer HALF2 = 3;           // High count in alternate period

    reg [2:0] cnt_rising;   // Counter on rising edge: counts 0 to 6
    reg [2:0] cnt_falling;  // Counter on falling edge: counts 0 to 6

    // Toggle flag to alternate between 4 and 3 high cycles
    // This determines which phase of the output pulse we're in
    reg toggle_phase;

    // Intermediate clock signals generated on rising and falling edges
    reg clk_rise;
    reg clk_fall;

    // Rising edge counter and phase toggle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_rising    <= 3'd0;
            toggle_phase  <= 1'b0;
            clk_rise     <= 1'b0;
        end else begin
            if (cnt_rising == MUL2_DIV_CLK - 1) begin
                cnt_rising   <= 3'd0;
                toggle_phase <= ~toggle_phase;
            end else begin
                cnt_rising <= cnt_rising + 1'b1;
            end

            // Generate clk_rise pulse:
            // For toggle_phase=0: high for 4 cycles (cnt < 4)
            // For toggle_phase=1: high for 3 cycles (cnt < 3)
            if (toggle_phase == 1'b0) begin
                clk_rise <= (cnt_rising < HALF1) ? 1'b1 : 1'b0;
            end else begin
                clk_rise <= (cnt_rising < HALF2) ? 1'b1 : 1'b0;
            end
        end
    end

    // Falling edge counter
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_falling <= 3'd0;
            clk_fall   <= 1'b0;
        end else begin
            if (cnt_falling == MUL2_DIV_CLK - 1) begin
                cnt_falling <= 3'd0;
            end else begin
                cnt_falling <= cnt_falling + 1'b1;
            end

            // For clk_fall, invert toggle_phase (phase shifted by half clock)
            // If rising edge phase is toggle_phase,
            // falling edge phase is ~toggle_phase
            if (toggle_phase == 1'b0) begin
                clk_fall <= (cnt_falling < HALF2) ? 1'b1 : 1'b0;
            end else begin
                clk_fall <= (cnt_falling < HALF1) ? 1'b1 : 1'b0;
            end
        end
    end

    // Output clock is OR of clk_rise and clk_fall to produce fractional division with balanced duty cycle
    assign clk_div = clk_rise | clk_fall;

endmodule