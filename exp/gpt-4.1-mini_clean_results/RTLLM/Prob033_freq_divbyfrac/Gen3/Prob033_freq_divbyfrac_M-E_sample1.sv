module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // We want to divide by 3.5 (i.e., toggle output every 3 or 4 input clocks alternately)
    // counter_max alternates between 3 and 4
    reg [2:0] counter;       // 3 bits to count up to 4
    reg       toggle_sel;    // 0 or 1: selects 3 or 4 for division steps

    // Next count target based on toggle_sel
    wire [2:0] count_target = toggle_sel ? 3'd4 : 3'd3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter    <= 3'd0;
            toggle_sel <= 1'b0;
            clk_div    <= 1'b0;
        end else begin
            if (counter == count_target - 1) begin
                counter <= 3'd0;
                toggle_sel <= ~toggle_sel;  // switch between 3 and 4 cycles
                clk_div <= ~clk_div;        // toggle output clock
            end else begin
                counter <= counter + 3'd1;
            end
        end
    end

endmodule