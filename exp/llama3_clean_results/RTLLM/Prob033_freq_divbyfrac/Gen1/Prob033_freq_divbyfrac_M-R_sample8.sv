module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,      // Active low reset signal
    output reg clk_div // Fractionally divided clock output
);

localparam MUL2_DIV_CLK = 7; // Counter cycles through 7 clock cycles

reg [2:0] counter; // Counter to generate uneven clock periods
reg div_clk;      // Intermediate divided clock signal
reg div_clk_delayed; // Phase-shifted version of div_clk (delayed by half a clock period)
reg div_clk_advanced; // Phase-shifted version of div_clk (advanced by half a clock period)

// Generate uneven clock periods (4 cycles and 3 cycles)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0; // Initialize counter to 0
    end else begin
        if (counter == 3'd3 || counter == 3'd6) begin
            counter <= 3'd0; // Reset counter
        end else begin
            counter <= counter + 1; // Increment counter
        end
    end
end

// Generate intermediate divided clock signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        div_clk <= 1'b0; // Initialize div_clk to 0
    end else begin
        if (counter == 3'd3 || counter == 3'd6) begin
            div_clk <= ~div_clk; // Toggle div_clk
        end
    end
end

// Generate phase-shifted versions of div_clk
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        div_clk_delayed <= 1'b0; // Initialize div_clk_delayed to 0
        div_clk_advanced <= 1'b0; // Initialize div_clk_advanced to 0
    end else begin
        div_clk_delayed <= div_clk; // Delay div_clk by half a clock period
        div_clk_advanced <= (counter == 3'd3 || counter == 3'd6)? ~div_clk : div_clk; // Advance div_clk by half a clock period
    end
end

// Generate final fractional divided clock output
assign clk_div = div_clk_delayed | div_clk_advanced; // Logically OR the phase-shifted versions of div_clk

endmodule