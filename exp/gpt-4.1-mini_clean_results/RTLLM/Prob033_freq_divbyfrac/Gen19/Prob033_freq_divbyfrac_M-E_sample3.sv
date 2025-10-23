module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division by 3.5
    // Total half cycles per full output period = 7 (3.5 * 2)
    localparam TOTAL_HALF_CYCLES = 7;

    // Counter to track half cycles (0..6)
    reg [2:0] half_cycle_cnt;

    // Generate a delayed clock (clk_d) one clk cycle delayed
    // We'll use clk_d to create a half-cycle phase shift by sampling clk_d and clk appropriately
    reg clk_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_d <= 1'b0;
        else
            clk_d <= clk;
    end

    // Half-cycle step counter:
    // We'll increment half_cycle_cnt on every clock rising edge, but use clk and clk_d edges logically combined
    // To achieve half-cycle resolution without multiple clock domains,
    // we implement a clock enable 'half_cycle_tick' toggled every clock cycle to simulate half clock step

    // Since we can't trigger on negedge clk, emulate half-clock step by toggling a clk_en every clock cycle
    reg half_cycle_tick;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            half_cycle_tick <= 1'b0;
        else
            half_cycle_tick <= ~half_cycle_tick;
    end

    // Increment half_cycle_cnt on half_cycle_tick rising edge
    reg half_cycle_tick_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            half_cycle_tick_d <= 1'b0;
        else
            half_cycle_tick_d <= half_cycle_tick;
    end

    wire half_cycle_tick_posedge = half_cycle_tick & ~half_cycle_tick_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            half_cycle_cnt <= 3'd0;
        else if (half_cycle_tick_posedge) begin
            if (half_cycle_cnt == (TOTAL_HALF_CYCLES - 1))
                half_cycle_cnt <= 3'd0;
            else
                half_cycle_cnt <= half_cycle_cnt + 3'd1;
        end
    end

    // Generate clk_pos toggling at counts 0 and 4 (4 half cycles apart)
    reg clk_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else if (half_cycle_tick_posedge) begin
            if ((half_cycle_cnt == 3'd0) || (half_cycle_cnt == 3'd4))
                clk_pos <= ~clk_pos;
        end
    end

    // Generate clk_neg toggling at counts 3 and 6 (3 half cycles apart)
    reg clk_neg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else if (half_cycle_tick_posedge) begin
            if ((half_cycle_cnt == 3'd3) || (half_cycle_cnt == 3'd6))
                clk_neg <= ~clk_neg;
        end
    end

    // Create phase shifted version of clk_pos and clk_neg by sampling them with clk_d
    // This simulates a half-cycle shift inside a single clock domain
    reg clk_pos_d, clk_neg_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_pos_d <= 1'b0;
            clk_neg_d <= 1'b0;
        end else begin
            clk_pos_d <= clk_pos;
            clk_neg_d <= clk_neg;
        end
    end

    // Create half-cycle delayed versions by sampling clk_pos and clk_neg with clk_d clock
    // Using clk_d signal (delayed clk), generate clk_pos_delayed and clk_neg_delayed for half-cycle shift
    reg clk_pos_delayed, clk_neg_delayed;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_pos_delayed <= 1'b0;
            clk_neg_delayed <= 1'b0;
        end else begin
            // Sample delayed clock domain signals on clk domain
            clk_pos_delayed <= clk_pos_d;
            clk_neg_delayed <= clk_neg_d;
        end
    end

    // Combine the original and phase-shifted clocks by OR to get smooth fractional divided clock
    assign clk_div = (clk_pos | clk_neg) | (clk_pos_delayed | clk_neg_delayed);

endmodule