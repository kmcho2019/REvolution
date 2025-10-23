`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10,       // Clock period in nanoseconds
    parameter DUTY_CYCLE = 50,   // Duty cycle percentage (1-99)
    parameter JITTER_EN = 0,     // Enable random jitter injection
    parameter REF_CLK_PER = 2    // Reference clock period (must be <= PERIOD/2)
) (
    input wire ref_clk,          // Reference clock input
    input wire reset_n,          // Active-low reset
    input wire clk_en,           // Clock enable
    output reg clk_out           // Generated clock output
);

    // Parameter validation
    initial begin
        if (PERIOD < 2*REF_CLK_PER) begin
            $display("Error: PERIOD must be >= 2*REF_CLK_PER");
            $finish;
        end
        if (DUTY_CYCLE < 1 || DUTY_CYCLE > 99) begin
            $display("Error: DUTY_CYCLE must be between 1-99");
            $finish;
        end
    end

    // Calculate timing parameters
    localparam COUNTER_MAX = (PERIOD/REF_CLK_PER) - 1;
    localparam HIGH_CYCLES = (COUNTER_MAX * DUTY_CYCLE) / 100;
    
    reg [31:0] counter = 0;
    reg [31:0] jitter_offset = 0;
    reg clk_en_sync;

    // Synchronize clock enable to reference clock
    always @(posedge ref_clk or negedge reset_n) begin
        if (!reset_n) begin
            clk_en_sync <= 0;
        end else begin
            clk_en_sync <= clk_en;
        end
    end

    // Generate jitter if enabled
    always @(posedge ref_clk) begin
        if (JITTER_EN && (counter == COUNTER_MAX)) begin
            jitter_offset <= {$random} % (PERIOD/10); // ±10% jitter
        end
    end

    // Main counter and clock generation
    always @(posedge ref_clk or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 0;
            clk_out <= 0;
        end else if (clk_en_sync) begin
            if (counter >= (COUNTER_MAX + jitter_offset)) begin
                counter <= 0;
                clk_out <= 1;
            end else if (counter == HIGH_CYCLES) begin
                clk_out <= 0;
                counter <= counter + 1;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            counter <= 0;
            clk_out <= 0;
        end
    end

    // Metastability protection (optional output buffer)
    (* ASYNC_REG = "TRUE" *) reg clk_out_meta;
    always @(posedge ref_clk) begin
        clk_out_meta <= clk_out;
    end

endmodule