module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    localparam CNT_WIDTH = $clog2(NUM_DIV);
    localparam PHASE_SHIFT = (NUM_DIV + 1)/2;  // Calculates the 180° phase point
    
    reg [CNT_WIDTH-1:0] counter;
    reg phase0, phase180;
    wire toggle_phase0, toggle_phase180;

    // Generate toggle signals for both phases
    assign toggle_phase0 = (counter == 0) || (counter == (NUM_DIV-1)/2);
    assign toggle_phase180 = (counter == PHASE_SHIFT) || (counter == PHASE_SHIFT + (NUM_DIV-1)/2);

    // Single counter operating on positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
        end else begin
            counter <= (counter == NUM_DIV-1) ? 0 : counter + 1;
        end
    end

    // Phase 0° clock generation (aligned with counter)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            phase0 <= 0;
        end else if (toggle_phase0) begin
            phase0 <= ~phase0;
        end
    end

    // Phase 180° clock generation (shifted by half cycle)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            phase180 <= 0;
        end else if (toggle_phase180) begin
            phase180 <= ~phase180;
        end
    end

    // Combine phases to create final output
    assign clk_div = phase0 | phase180;

endmodule