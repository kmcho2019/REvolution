module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Generate internal clk_2x by toggling at negedge clk (half clock period)
    reg clk_2x;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_2x <= 1'b0;
        else
            clk_2x <= ~clk_2x;
    end

    // 3-bit counter counts modulo 7 on posedge clk_2x (double frequency clock)
    reg [2:0] cnt;
    always @(posedge clk_2x or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == 3'd6)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_out_posedge: high for counts 0..3 (4 half-cycles), low for 4..6 (3 half-cycles)
    wire clk_out_posedge = (cnt <= 3'd3);

    // clk_out_negedge: same pattern but phase shifted by 1 count (modulo 7)
    // To avoid modulo operator, implement a function:
    function [2:0] add_one_mod7(input [2:0] val);
        begin
            if (val == 3'd6)
                add_one_mod7 = 3'd0;
            else
                add_one_mod7 = val + 3'd1;
        end
    endfunction

    wire [2:0] cnt_shift = add_one_mod7(cnt);
    wire clk_out_negedge = (cnt_shift <= 3'd3);

    // Final fractional divided clock output by ORing the two phase shifted signals
    assign clk_div = clk_out_posedge | clk_out_negedge;

endmodule