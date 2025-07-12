module freq_divbyfrac(
    input           clk,        // Input clock signal
    input           rst_n,      // Active low reset signal
    output          clk_div     // Fractionally divided clock output
);

// Parameters for fractional frequency division (3.5x)
parameter MUL2_DIV_CLK = 7;    // Total clock cycles for fractional division
parameter DIV_CLK_HIGH = 4;    // Number of clock cycles for the high period
parameter DIV_CLK_LOW = 3;     // Number of clock cycles for the low period

// Internal signals
reg [2:0] count;               // Counter to cycle through MUL2_DIV_CLK
reg clk_int;                  // Intermediate divided clock signal
reg clk_int_phase_shifted;    // Phase-shifted version of the intermediate clock

// Counter to cycle through MUL2_DIV_CLK
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count <= 3'b000;
    end else if (count == MUL2_DIV_CLK - 1) begin
        count <= 3'b000;
    end else begin
        count <= count + 1'b1;
    end
end

// Generate the intermediate divided clock signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_int <= 1'b0;
    end else if (count < DIV_CLK_HIGH) begin
        clk_int <= 1'b1;
    end else begin
        clk_int <= 1'b0;
    end
end

// Phase-shift the intermediate clock signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_int_phase_shifted <= 1'b0;
    end else if (count == DIV_CLK_HIGH) begin
        clk_int_phase_shifted <= 1'b1;
    end else if (count == MUL2_DIV_CLK - 1) begin
        clk_int_phase_shifted <= 1'b0;
    end else begin
        clk_int_phase_shifted <= clk_int_phase_shifted;
    end
end

// Generate the final fractional divided clock output
assign clk_div = clk_int | clk_int_phase_shifted;

endmodule