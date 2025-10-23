module freq_divbyfrac(
    input         clk,        // Input clock signal
    input         rst_n,      // Active low reset signal
    output        clk_div     // Fractionally divided clock output
);

// Define the parameter for fractional division (3.5x)
parameter MUL2_DIV_CLK = 7;   // Total clock cycles for fractional division

// Internal signals for divided clock and phase-shifted clocks
reg [2:0]       cnt;          // Counter for divided clock cycles
reg             clk_div_int;  // Intermediate divided clock signal
reg             clk_div_delay; // Delayed phase of divided clock
reg             clk_div_adv;   // Advanced phase of divided clock

// Counter logic to generate divided clock
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div_int <= 1'b0;
        clk_div_delay <= 1'b0;
        clk_div_adv <= 1'b0;
    end else begin
        if (cnt == 3'b110) begin // 6 cycles passed
            cnt <= 3'b001;       // Reset counter
            clk_div_int <= 1'b1; // Set intermediate divided clock high
        end else if (cnt == 3'b011) begin // 3 cycles passed
            cnt <= cnt + 1'b1;
            clk_div_int <= 1'b0; // Set intermediate divided clock low
        end else if (cnt == 3'b101) begin // 5 cycles passed
            cnt <= cnt + 1'b1;
            clk_div_int <= 1'b0; // Set intermediate divided clock low
        end else begin
            cnt <= cnt + 1'b1;   // Increment counter
        end

        // Phase-shifting logic
        if (cnt == 3'b001) begin
            clk_div_delay <= 1'b1; // Set delayed phase high
            clk_div_adv <= 1'b0;   // Set advanced phase low
        end else if (cnt == 3'b100) begin
            clk_div_delay <= 1'b0; // Set delayed phase low
            clk_div_adv <= 1'b1;   // Set advanced phase high
        end else begin
            clk_div_delay <= clk_div_delay;
            clk_div_adv <= clk_div_adv;
        end
    end
end

// Logical OR operation to produce final fractional divided clock output
assign clk_div = clk_div_int || (clk_div_delay && ~clk_div_adv);

endmodule