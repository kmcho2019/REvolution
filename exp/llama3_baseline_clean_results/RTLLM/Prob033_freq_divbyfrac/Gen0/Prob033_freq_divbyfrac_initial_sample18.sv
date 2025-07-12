module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7; // Total cycles for 3.5x division
parameter DIV CLK_HALFPeriod = 4; // Uneven clock period with 4 source clock cycles
parameter DIV CLK_HALFPeriod_NEXT = 3; // Uneven clock period with 3 source clock cycles

// Internal signals
reg [2:0] counter; // Counter for 7 clock cycles
reg div_clk_int; // Intermediate divided clock signal
reg div_clk_int_next; // Phase-shifted version of the divided clock signal
reg div_clk_int_delayed; // Delayed version of the divided clock signal
reg div_clk_int_advanced; // Advanced version of the divided clock signal

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

// Generate intermediate divided clock signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        div_clk_int <= 1'b0;
    end else begin
        if (counter == DIV_CLK_HALFPeriod - 1) begin
            div_clk_int <= 1'b1;
        end else if (counter == DIV_CLK_HALFPeriod_NEXT + 1) begin
            div_clk_int <= 1'b0;
        end
    end
end

// Generate phase-shifted versions of the divided clock signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        div_clk_int_delayed <= 1'b0;
        div_clk_int_advanced <= 1'b0;
    end else begin
        div_clk_int_delayed <= div_clk_int;
        div_clk_int_advanced <= div_clk_int;
    end
end

// OR the two intermediate clocks to produce the final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        if (counter == DIV_CLK_HALFPeriod - 1) begin
            div_clk_int_next <= 1'b1;
        end else if (counter == DIV_CLK_HALFPeriod_NEXT + 1) begin
            div_clk_int_next <= 1'b0;
        end
        clk_div <= div_clk_int_next || div_clk_int;
    end
end

// Add a delay of half a clock period to div_clk_int_delayed
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        div_clk_int_delayed <= 1'b0;
    end else begin
        div_clk_int_delayed <= div_clk_int;
    end
end

// Add an advance of half a clock period to div_clk_int_advanced
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        div_clk_int_advanced <= 1'b0;
    end else begin
        if (counter == DIV_CLK_HALFPeriod - 1) begin
            div_clk_int_advanced <= 1'b1;
        end else if (counter == DIV_CLK_HALFPeriod_NEXT + 1) begin
            div_clk_int_advanced <= 1'b0;
        end
    end
end

// Final fractional divided clock output
assign clk_div = div_clk_int || div_clk_int_delayed || div_clk_int_advanced;

endmodule