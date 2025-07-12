module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
localparam MUL2_DIV_CLK = 7;
localparam DIV_CLK_HIGH = 4;
localparam DIV_CLK_LOW = 3;

// Counter to cycle through clock cycles
reg [2:0] counter;

// Intermediate clocks
reg clk_div_int1;
reg clk_div_int2;

// Phase-shifted intermediate clocks
reg clk_div_int1_delayed;
reg clk_div_int2_advanced;

// Internal signals
reg clk_div_int1_r;
reg clk_div_int2_r;

always @(*) begin
    // Generate intermediate clocks
    if (counter < DIV_CLK_HIGH) begin
        clk_div_int1 = 1'b1;
    end else begin
        clk_div_int1 = 1'b0;
    end

    if (counter < DIV_CLK_LOW) begin
        clk_div_int2 = 1'b1;
    end else begin
        clk_div_int2 = 1'b0;
    end
end

// Phase-shift intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_int1_r <= 1'b0;
        clk_div_int2_r <= 1'b0;
    end else begin
        clk_div_int1_r <= clk_div_int1;
        clk_div_int2_r <= clk_div_int2;
    end
end

assign clk_div_int1_delayed = clk_div_int1_r;
assign clk_div_int2_advanced = (counter == 0) ? 1'b1 : clk_div_int2;

// Generate final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_div_int1_delayed | clk_div_int2_advanced;
    end
end

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

endmodule