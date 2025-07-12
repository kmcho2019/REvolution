module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg prev_clk;   // Previous clock value for edge detection
reg clk_div_int;  // Intermediate divided clock signal

// Sequential logic for counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        prev_clk <= 1'b0;
        clk_div_int <= 1'b0;
    end else begin
        prev_clk <= clk;
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        // Generate divided clock signal
        if ((cnt == 1 || cnt == 4) && clk && !prev_clk) begin
            clk_div_int <= 1'b1;
        end else if ((cnt == 1 || cnt == 4) && !clk && prev_clk) begin
            clk_div_int <= 1'b0;
        end
    end
end

// Phase-shifting logic to adjust duty cycle imbalance
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        // Phase-shift divided clock signal
        if (cnt == 1 || cnt == 4) begin
            if (clk_div_int && !prev_clk) begin
                clk_div <= 1'b1;
            end else if (!clk_div_int && prev_clk) begin
                clk_div <= 1'b0;
            end
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule