module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

localparam MUL2_DIV_CLK = 7; // Twice the division factor (3.5 * 2)

reg [2:0] cnt;         // 3-bit counter: counts 0 to 6
reg clk_div_posedge;   // Divided clock based on posedge counting
reg clk_div_negedge;   // Divided clock based on negedge counting

// Counter increments on rising edge of clk or resets
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'd0;
        clk_div_posedge <= 1'b0;
    end else begin
        if (cnt == (MUL2_DIV_CLK - 1))
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;

        // Toggle clk_div_posedge at counts 3 and 6 to generate uneven periods: 4 then 3 cycles
        // From count 0 to 3: clk_div_posedge = 0
        // From count 4 to 6: clk_div_posedge = 1
        if (cnt == 3 || cnt == 6)
            clk_div_posedge <= ~clk_div_posedge;
    end
end

// clk_div_negedge toggles on the falling edge of clk to produce a half-cycle phase shift
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_negedge <= 1'b0;
    end else begin
        // Using same counts as posedge domain to toggle clk_div_negedge with half-clock offset
        // We need to synchronize count to negedge domain, so latch 'cnt' at negedge clk
        // Create a sampled count at negedge clk:
        // Because 'cnt' updates at posedge clk, 'cnt' is stable during negedge clk.
        if (cnt == 3 || cnt == 6)
            clk_div_negedge <= ~clk_div_negedge;
    end
end

// The final fractional divided clock is the OR of both phase-shifted clocks
assign clk_div = clk_div_posedge | clk_div_negedge;

endmodule