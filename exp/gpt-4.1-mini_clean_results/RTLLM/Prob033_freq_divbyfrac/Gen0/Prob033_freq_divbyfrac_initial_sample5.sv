module freq_divbyfrac (
    input  wire clk,     // Input clock
    input  wire rst_n,   // Active low reset
    output wire clk_div  // Fractionally divided clock output
);

    localparam integer MUL2_DIV_CLK = 7;

    reg [2:0] cnt_rise;
    reg [2:0] cnt_fall;

    // These signals toggle to form the two phase-shifted clocks
    reg div_clk_rise;
    reg div_clk_fall;

    // Rising edge logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_rise    <= 0;
            div_clk_rise <= 0;
        end else begin
            if (cnt_rise == MUL2_DIV_CLK-1)
                cnt_rise <= 0;
            else
                cnt_rise <= cnt_rise + 1;

            // Generate duty cycle: high for 4 cycles, low for 3 cycles
            // So div_clk_rise is high when cnt_rise < 4
            div_clk_rise <= (cnt_rise < 4) ? 1'b1 : 1'b0;
        end
    end

    // Falling edge logic
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_fall    <= 0;
            div_clk_fall <= 0;
        end else begin
            if (cnt_fall == MUL2_DIV_CLK-1)
                cnt_fall <= 0;
            else
                cnt_fall <= cnt_fall + 1;

            // Generate the same pattern but offset by half clk period relative to rise
            div_clk_fall <= (cnt_fall < 4) ? 1'b1 : 1'b0;
        end
    end

    // The final output is the OR of the two phase shifted clocks
    assign clk_div = div_clk_rise | div_clk_fall;

endmodule