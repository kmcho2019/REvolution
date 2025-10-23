module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided clock output (3.5x division)
);

    // Counter counts from 0 to 6 (modulo 7)
    reg [2:0] cnt_pos; // Counter incremented on positive edge
    reg [2:0] cnt_neg; // Counter incremented on negative edge (shadow copy for phase180)

    // Intermediate clocks
    reg clk_phase0;    // toggles on posedge clk at cnt_pos 3 and 6
    reg clk_phase180;  // toggles on negedge clk at cnt_neg 0 and 3

    // POSITIVE EDGE: counter and clk_phase0 toggling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos    <= 3'd0;
            clk_phase0 <= 1'b0;
        end else begin
            // Increment modulo 7
            if (cnt_pos == 3'd6)
                cnt_pos <= 3'd0;
            else
                cnt_pos <= cnt_pos + 3'd1;

            // Toggle clk_phase0 at counts 3 and 6 to create uneven periods (4 and 3 cycles)
            if ((cnt_pos == 3'd3) || (cnt_pos == 3'd6)) begin
                clk_phase0 <= ~clk_phase0;
            end
        end
    end

    // NEGATIVE EDGE: counter and clk_phase180 toggling (phase-shifted)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg     <= 3'd0;
            clk_phase180 <= 1'b0;
        end else begin
            // Increment modulo 7
            if (cnt_neg == 3'd6)
                cnt_neg <= 3'd0;
            else
                cnt_neg <= cnt_neg + 3'd1;

            // Toggle clk_phase180 at counts 0 and 3 (phase shifted by half clk period)
            if ((cnt_neg == 3'd0) || (cnt_neg == 3'd3)) begin
                clk_phase180 <= ~clk_phase180;
            end
        end
    end

    // Output is logical OR of two phase-shifted intermediate clocks
    assign clk_div = clk_phase0 | clk_phase180;

endmodule