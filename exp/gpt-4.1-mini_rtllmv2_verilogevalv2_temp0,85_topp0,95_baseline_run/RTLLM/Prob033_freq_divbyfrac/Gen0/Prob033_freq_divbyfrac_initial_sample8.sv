module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for 3.5 division (7/2)
    localparam integer MUL2_DIV_CLK = 7;

    reg [2:0] cnt_rise;  // Counter on rising edge
    reg [2:0] cnt_fall;  // Counter on falling edge

    reg clk_div_rise;    // Intermediate clock toggled on rising edge
    reg clk_div_fall;    // Intermediate clock toggled on falling edge

    // Rising edge counter and clk_div_rise generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_rise     <= 3'd0;
            clk_div_rise <= 1'b0;
        end else begin
            if (cnt_rise == MUL2_DIV_CLK-1)
                cnt_rise <= 3'd0;
            else
                cnt_rise <= cnt_rise + 3'd1;

            // Toggle clk_div_rise at count 3 (after 4 cycles)
            // and count 6 (after 7 cycles, then reset)
            if ((cnt_rise == 3'd3) || (cnt_rise == 3'd6))
                clk_div_rise <= ~clk_div_rise;
        end
    end

    // Falling edge counter and clk_div_fall generation
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_fall     <= 3'd0;
            clk_div_fall <= 1'b0;
        end else begin
            if (cnt_fall == MUL2_DIV_CLK-1)
                cnt_fall <= 3'd0;
            else
                cnt_fall <= cnt_fall + 3'd1;

            // Toggle clk_div_fall at count 2 (after 3 cycles)
            // and count 5 (after 6 cycles, then reset)
            if ((cnt_fall == 3'd2) || (cnt_fall == 3'd5))
                clk_div_fall <= ~clk_div_fall;
        end
    end

    // Final output clock is OR of phase-shifted intermediate clocks
    assign clk_div = clk_div_rise | clk_div_fall;

endmodule