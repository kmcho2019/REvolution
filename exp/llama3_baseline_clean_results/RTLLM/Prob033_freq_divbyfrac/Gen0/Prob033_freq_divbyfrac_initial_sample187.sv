module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define parameters for the frequency division
parameter MUL2_DIV_CLK = 7; // Clock cycles for 3.5x division
parameter DIV_CLK_HIGH = 4; // Clock cycles for high phase
parameter DIV_CLK_LOW = 3; // Clock cycles for low phase

// Initialize counters and signals
reg [2:0] cnt; // Counter for clock cycles
reg clk_div_int; // Intermediate divided clock signal
reg clk_div_delayed; // Delayed phase-shifted clock signal
reg clk_div_advanced; // Advanced phase-shifted clock signal

// Clock cycle counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b000;
    end else if (cnt == MUL2_DIV_CLK - 1) begin
        cnt <= 3'b000;
    end else begin
        cnt <= cnt + 1;
    end
end

// Generate intermediate divided clock signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_int <= 1'b0;
    end else if (cnt < DIV_CLK_HIGH) begin
        clk_div_int <= 1'b1;
    end else begin
        clk_div_int <= 1'b0;
    end
end

// Generate phase-shifted clock signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_delayed <= 1'b0;
        clk_div_advanced <= 1'b0;
    end else begin
        // Delayed phase-shifted clock signal
        if (cnt == DIV_CLK_HIGH - 1) begin
            clk_div_delayed <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_delayed <= 1'b0;
        end else begin
            clk_div_delayed <= clk_div_delayed;
        end
        
        // Advanced phase-shifted clock signal
        if (cnt == DIV_CLK_LOW) begin
            clk_div_advanced <= 1'b1;
        end else if (cnt == DIV_CLK_LOW + (MUL2_DIV_CLK / 2)) begin
            clk_div_advanced <= 1'b0;
        end else begin
            clk_div_advanced <= clk_div_advanced;
        end
    end
end

// Generate final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else begin
        // Logically OR the phase-shifted clocks
        clk_div <= clk_div_int || clk_div_delayed || clk_div_advanced;
    end
end

endmodule