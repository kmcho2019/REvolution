module freq_divbyfrac (
    input  wire        clk,
    input  wire        rst_n,
    output reg         clk_div
);

// Parameters for the fractional frequency division
localparam MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
localparam DIV_CLK_1 = 4;     // Clock cycles for the first divided clock period
localparam DIV_CLK_2 = 3;     // Clock cycles for the second divided clock period

// Internal signals
reg [2:0]  counter;           // Counter to track clock cycles
reg        clk_div_1;         // First intermediate divided clock
reg        clk_div_2;         // Second intermediate divided clock
reg        clk_div_1_shifted; // Phase-shifted version of the first divided clock
reg        clk_div_2_shifted; // Phase-shifted version of the second divided clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000;
    end else begin
        counter <= counter + 1'b1;
    end
end

// Generate the first intermediate divided clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_1 <= 1'b0;
    end else if (counter == DIV_CLK_1 - 1) begin
        clk_div_1 <= 1'b1;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        clk_div_1 <= 1'b0;
    end else begin
        clk_div_1 <= clk_div_1;
    end
end

// Generate the second intermediate divided clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_2 <= 1'b0;
    end else if (counter == DIV_CLK_2 - 1) begin
        clk_div_2 <= 1'b1;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        clk_div_2 <= 1'b0;
    end else begin
        clk_div_2 <= clk_div_2;
    end
end

// Generate the phase-shifted versions of the divided clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_1_shifted <= 1'b0;
        clk_div_2_shifted <= 1'b0;
    end else begin
        // Delay the first divided clock by half a clock period
        clk_div_1_shifted <= (counter == DIV_CLK_1 - 2) ? 1'b1 : (counter == MUL2_DIV_CLK - 2) ? 1'b0 : clk_div_1_shifted;
        
        // Advance the second divided clock by half a clock period
        clk_div_2_shifted <= (counter == DIV_CLK_2 - 2) ? 1'b1 : (counter == MUL2_DIV_CLK - 2) ? 1'b0 : clk_div_2_shifted;
    end
end

// Generate the final fractional divided clock output
assign clk_div = clk_div_1 | clk_div_2 | clk_div_1_shifted | clk_div_2_shifted;

endmodule