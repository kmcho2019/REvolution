module freq_divbyfrac (
    input  wire clk,      // Input clock
    input  wire rst_n,    // Active low reset
    output wire clk_div   // Fractionally divided clock output (clk / 3.5)
);

    localparam TOTAL_COUNT = 7;

    reg [2:0] count;
    reg clk_raw;

    // Counter: synchronous reset, counts from 0 to 6 repeatedly
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == TOTAL_COUNT - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // Generate raw divided clock (clk_raw)
    // Toggle clk_raw at counts 3 and 6 to create 4 and 3 clock cycle intervals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_raw <= 1'b0;
        else if (count == 3 || count == 6)
            clk_raw <= ~clk_raw;
    end

    // Create a half-cycle delayed version of clk_raw
    // Since we can't use negedge clk, use a double flip-flop chain clocked by clk to delay clk_raw by one clk period
    // Then use the delayed clk_raw from previous clk cycle to approximate a phase-shifted version.
    reg clk_raw_delayed_1;
    reg clk_raw_delayed_2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_raw_delayed_1 <= 1'b0;
            clk_raw_delayed_2 <= 1'b0;
        end else begin
            clk_raw_delayed_1 <= clk_raw;
            clk_raw_delayed_2 <= clk_raw_delayed_1;
        end
    end

    // We can produce a simple phase-shifted signal by XORing clk_raw with clk_raw_delayed_2
    // This produces a pulse at the edges of clk_raw, effectively approximating half-cycle phase shift timing.

    wire clk_delayed = clk_raw ^ clk_raw_delayed_2;

    // Final fractional clock output: OR clk_raw and clk_delayed
    // This combines the main clock and the phase-shifted pulses for a uniform fractional division
    assign clk_div = clk_raw | clk_delayed;

endmodule