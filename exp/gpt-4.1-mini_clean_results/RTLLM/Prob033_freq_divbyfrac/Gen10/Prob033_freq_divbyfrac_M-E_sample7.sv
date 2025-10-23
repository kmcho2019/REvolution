module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Counter modulo 7
    reg [2:0] counter;
    // Output signal driven on posedge clock: toggles every 4 and 3 cycles (uneven)
    reg clk_out_posedge;
    // Output signal driven on negedge clock: toggles every 4 and 3 cycles but phase-shifted by half cycle
    reg clk_out_negedge;

    // Pattern defining high and low durations (in input clock cycles)
    // We implement a state machine to toggle output every 4 or 3 cycles
    // to produce 3.5 division (period = 7 cycles)
    // For posedge clock toggling, the high duration is 4, low is 3
    // For negedge clock toggling, the toggle moments are shifted by one clock cycle for phase shift

    // Counters to track how many input cycles the output has been high or low
    reg [2:0] count_pos;
    reg       state_pos;   // 1: high, 0: low

    reg [2:0] count_neg;
    reg       state_neg;   // 1: high, 0: low

    // We handle the toggling on posedge and negedge separately to get a half-clock phase shift

    // POSITIVE EDGE PROCESS
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_pos     <= 3'd0;
            state_pos     <= 1'b0;
            clk_out_posedge <= 1'b0;
        end else begin
            // Increment count each clock
            count_pos <= count_pos + 3'd1;

            // Decide toggle condition based on current state and count
            if (state_pos == 1'b1) begin
                // Currently high: hold for 4 cycles
                if (count_pos == 3'd3) begin
                    // After 4 cycles (0..3), toggle low
                    state_pos     <= 1'b0;
                    count_pos     <= 3'd0;
                    clk_out_posedge <= 1'b0;
                end
            end else begin
                // Currently low: hold for 3 cycles
                if (count_pos == 3'd2) begin
                    // After 3 cycles (0..2), toggle high
                    state_pos     <= 1'b1;
                    count_pos     <= 3'd0;
                    clk_out_posedge <= 1'b1;
                end
            end
        end
    end

    // NEGATIVE EDGE PROCESS: similar logic but phase shifted by one clock cycle relative to posedge
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_neg     <= 3'd0;
            state_neg     <= 1'b1;  // Start opposite phase to posedge clk_out for better 50% duty
            clk_out_negedge <= 1'b1;
        end else begin
            count_neg <= count_neg + 3'd1;

            if (state_neg == 1'b1) begin
                // high for 4 cycles on negedge clock count
                if (count_neg == 3'd3) begin
                    state_neg <= 1'b0;
                    count_neg <= 3'd0;
                    clk_out_negedge <= 1'b0;
                end
            end else begin
                // low for 3 cycles
                if (count_neg == 3'd2) begin
                    state_neg <= 1'b1;
                    count_neg <= 3'd0;
                    clk_out_negedge <= 1'b1;
                end
            end
        end
    end

    // Combine the two phase-shifted outputs by XOR to get a ~50% duty cycle fractional clock
    // The XOR produces transitions at both edges to create an effective frequency of clk/3.5
    assign clk_div = clk_out_posedge ^ clk_out_negedge;

endmodule