module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    reg [6:0] cnt; // 0 to 99 to count 100 cycles

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Increment counter and wrap at 99
            if (cnt == 7'd99)
                cnt <= 7'd0;
            else
                cnt <= cnt + 7'd1;

            // CLK_50: toggle every cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10: toggle when cnt mod 10 == 4 (toggle in middle of 10-cycle)
            // Because toggling at count 4 toggles output every 5 cycles (to get 10 cycles full period)
            if (cnt % 10 == 7'd4)
                CLK_10 <= ~CLK_10;

            // CLK_1: toggle when cnt == 49 (halfway through 100 cycles)
            if (cnt == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule