module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg phase_error;  // Phase error signal
reg vco_enable;  // VCO enable signal
reg [3:0] vco_cnt;  // VCO counter

// Phase detector
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        phase_error <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            phase_error <= 1'b1;
        end else begin
            phase_error <= 1'b0;
        end
    end
end

// Loop filter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        vco_enable <= 1'b0;
    end else begin
        if (phase_error) begin
            vco_enable <= 1'b1;
        end else begin
            vco_enable <= 1'b0;
        end
    end
end

// VCO
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        vco_cnt <= 4'b0000;
    end else if (vco_enable) begin
        vco_cnt <= vco_cnt + 1'b1;
    end else begin
        vco_cnt <= 4'b0000;
    end
end

// Duty cycle correction
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else if (vco_cnt == 4'b1000) begin
        clk_div <= 1'b1;
    end else if (vco_cnt == 4'b0100) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_div;
    end
end

// Counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
    end else if (cnt == MUL2_DIV_CLK - 1) begin
        cnt <= 3'b000;
    end else begin
        cnt <= cnt + 1'b1;
    end
end

endmodule