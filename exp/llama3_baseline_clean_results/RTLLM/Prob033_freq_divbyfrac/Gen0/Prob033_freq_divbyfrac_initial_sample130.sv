module freq_divbyfrac(
    input         clk,    // Input clock signal
    input         rst_n,  // Active low reset signal
    output        clk_div // Fractionally divided clock output
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division
parameter LONG_PULSE = 4;   // Clock cycles for long pulse
parameter SHORT_PULSE = 3;  // Clock cycles for short pulse

reg [2:0] counter; // Counter for 7-clock cycle period
reg phase;         // Phase tracking signal
reg [1:0] phase_cnt; // Phase counter
reg clk_int;        // Intermediate clock signal
reg clk_long;       // Long pulse clock signal
reg clk_short;      // Short pulse clock signal
reg clk_div_delayed; // Delayed divided clock signal
reg clk_div_advanced; // Advanced divided clock signal

// Counter and phase tracking
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        phase <= 0;
        phase_cnt <= 0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 0;
            phase <= ~phase;
        end else begin
            counter <= counter + 1;
        end

        if (phase_cnt == 1) begin
            phase_cnt <= 0;
        end else begin
            phase_cnt <= phase_cnt + 1;
        end
    end
end

// Generate intermediate clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_int <= 0;
        clk_long <= 0;
        clk_short <= 0;
    end else begin
        if (phase) begin // Long pulse
            if (counter < LONG_PULSE - 1) begin
                clk_long <= 1;
            end else begin
                clk_long <= 0;
            end
        end else begin // Short pulse
            if (counter < SHORT_PULSE - 1) begin
                clk_short <= 1;
            end else begin
                clk_short <= 0;
            end
        end

        // Generate intermediate clock
        if (phase) begin
            clk_int <= clk_long;
        end else begin
            clk_int <= clk_short;
        end
    end
end

// Phase-shifting
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_delayed <= 0;
        clk_div_advanced <= 0;
    end else begin
        if (phase_cnt == 1) begin
            clk_div_delayed <= clk_int;
        end

        if (phase_cnt == 0) begin
            clk_div_advanced <= clk_int;
        end
    end
end

// Final divided clock output
assign clk_div = clk_div_delayed | clk_div_advanced;

endmodule