module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] main_cnt; // 7 bits to count 0..99

    always @(posedge CLK_in) begin
        if (RST) begin
            main_cnt <= 7'd0;
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
        end else begin
            if (main_cnt == 7'd99)
                main_cnt <= 7'd0;
            else
                main_cnt <= main_cnt + 7'd1;

            // CLK_50: toggle every cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10: toggle every 5 cycles (at main_cnt == 4,14,24,...)
            // Since main_cnt cycles 0..99, toggling at main_cnt mod 10 == 4 (every 5 cycles)
            if (main_cnt % 10 == 7'd4)
                CLK_10 <= ~CLK_10;

            // CLK_1: toggle every 50 cycles (at main_cnt == 49 and 99)
            if ((main_cnt == 7'd49) || (main_cnt == 7'd99))
                CLK_1 <= ~CLK_1;
        end
    end

endmodule