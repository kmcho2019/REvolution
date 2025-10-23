module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);
    // Parameters
    localparam CNT_MAX = 7;  // count 0..6

    reg [2:0] counter;
    reg clk_pos;       // divided clock: high 4 cycles, low 3 cycles
    reg clk_pos_dly;   // delayed version of clk_pos by one clk cycle

    // Counter and clk_pos generation: synchronous logic on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 3'd0;
            clk_pos <= 1'b0;
            clk_pos_dly <= 1'b0;
        end else begin
            if (counter == CNT_MAX - 1)
                counter <= 3'd0;
            else
                counter <= counter + 3'd1;

            // clk_pos high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
            clk_pos <= (counter <= 3'd3);

            // clk_pos_dly: delayed version of clk_pos by one clk cycle
            clk_pos_dly <= clk_pos;
        end
    end

    // Final divided clock: OR of clk_pos and its delayed version
    // This creates a roughly half-cycle phase shift, smoothing the output waveform
    assign clk_div = clk_pos | clk_pos_dly;

endmodule