module freq_divbyfrac (
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter DIV_CLK_HALF_PERIOD = 4; // Clock cycles for the first half of the divided clock period
parameter DIV_CLK_ADVANCE = 3; // Clock cycles for the second half of the divided clock period

// Internal signals
reg [2:0] counter; // Counter to cycle through 7 clock cycles
reg clk_div_int; // Intermediate divided clock signal
reg clk_div_int_delayed; // Delayed version of the intermediate divided clock signal
reg clk_div_int_advanced; // Advanced version of the intermediate divided clock signal

// Counter logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000; // Reset counter to 0
    end else begin
        counter <= counter + 1; // Increment counter
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000; // Reset counter after 7 clock cycles
        end
    end
end

// Generate intermediate divided clock signal
always @ (posedge clk) begin
    if (counter < DIV_CLK_HALF_PERIOD) begin
        clk_div_int <= 1'b1; // First half of the divided clock period
    end else begin
        clk_div_int <= 1'b0; // Second half of the divided clock period
    end
end

// Generate delayed and advanced versions of the intermediate divided clock signal
always @ (posedge clk) begin
    clk_div_int_delayed <= clk_div_int; // Delayed version of the intermediate divided clock signal
end

always @ (negedge clk) begin
    clk_div_int_advanced <= clk_div_int; // Advanced version of the intermediate divided clock signal
end

// Generate final fractionally divided clock output
assign clk_div = clk_div_int | clk_div_int_advanced;

endmodule