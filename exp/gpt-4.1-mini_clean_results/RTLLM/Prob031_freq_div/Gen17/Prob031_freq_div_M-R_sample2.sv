module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] counter;  // 0 to 99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // increment counter, wrap at 99
            if (counter == 7'd99)
                counter <= 7'd0;
            else
                counter <= counter + 7'd1;

            // CLK_50 toggles every clock (divide by 2)
            // The LSB of counter toggles every cycle:
            // Alternatively, just toggle CLK_50 at every clock edge
            // But since counter increments every cycle, toggle CLK_50 when counter LSB toggles
            // Simpler: just toggle every cycle to divide by 2
            CLK_50 <= ~CLK_50;

            // CLK_10 toggles every 5 clock cycles (counter == 4,9,14,...)
            // Since 10MHz = 100MHz/10, toggling every 5 cycles
            // So toggle CLK_10 when counter == 4 or 9 or 14 ... i.e. counter mod 10 ==4
            if (counter % 10 == 7'd4)
                CLK_10 <= ~CLK_10;

            // CLK_1 toggles every 50 clock cycles (counter == 49, 99)
            if (counter == 7'd49 || counter == 7'd99)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule