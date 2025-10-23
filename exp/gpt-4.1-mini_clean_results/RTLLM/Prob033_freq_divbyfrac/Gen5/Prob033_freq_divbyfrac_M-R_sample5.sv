module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Counter runs from 0 to 6, representing half clock cycles for 3.5 division
    reg [2:0] cnt;

    // Intermediate clocks: clk_a toggles at counts 0 and 4 (high for 4 half cycles, low for 3)
    // clk_b toggles at counts 3 and 6, phase-shifted by half a clock period relative to clk_a
    reg clk_a;
    reg clk_b;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt   <= 3'd0;
            clk_a <= 1'b0;
            clk_b <= 1'b0;
        end else begin
            if (cnt == 3'd6)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // clk_a toggles at counts 0 and 4 to create 4 and 3 half cycle phases
            if (cnt == 3'd0 || cnt == 3'd4)
                clk_a <= ~clk_a;

            // clk_b toggles at counts 3 and 6, producing the half clock period phase shift
            if (cnt == 3'd3 || cnt == 3'd6)
                clk_b <= ~clk_b;
        end
    end

    // Final fractional clock is the OR of the two phase-shifted clocks
    assign clk_div = clk_a | clk_b;

endmodule