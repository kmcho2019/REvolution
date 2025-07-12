module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_MOD = 7;

    // Counter for clk_intA (posedge)
    reg [2:0] cntA;
    reg       clk_intA;

    // Counter for clk_intB (negedge)
    reg [2:0] cntB;
    reg       clk_intB;

    // clk_intA logic - toggles with uneven periods on posedge clk
    // Periods: high for 4 cycles, low for 3 cycles alternating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cntA    <= 3'd0;
            clk_intA <= 1'b0;
        end else begin
            if (cntA == DIV_MOD - 1)
                cntA <= 3'd0;
            else
                cntA <= cntA + 3'd1;

            // Toggle clk_intA at counts 3 and 6 (uneven periods)
            // The toggle points split 7 cycles into 4 and 3 periods
            if (cntA == 3'd3 || cntA == 3'd6)
                clk_intA <= ~clk_intA;
        end
    end

    // clk_intB logic - toggles with uneven periods on negedge clk
    // This clock is phase-shifted by half input clk period
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cntB    <= 3'd0;
            clk_intB <= 1'b0;
        end else begin
            if (cntB == DIV_MOD - 1)
                cntB <= 3'd0;
            else
                cntB <= cntB + 3'd1;

            // Toggle clk_intB at counts 3 and 6, same as clk_intA but on negedge clk
            if (cntB == 3'd3 || cntB == 3'd6)
                clk_intB <= ~clk_intB;
        end
    end

    // Combine two phase-shifted clocks by OR operation to get fractional clk_div
    assign clk_div = clk_intA | clk_intB;

endmodule