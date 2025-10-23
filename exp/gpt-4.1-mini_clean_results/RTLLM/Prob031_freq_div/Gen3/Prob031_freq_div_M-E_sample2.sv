module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Unified counter running from 0 to 99 (for 1 MHz period)
    reg [6:0] cnt; // 7 bits to count up to 100

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt    <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Increment counter or reset if max period reached
            if (cnt == 7'd99)
                cnt <= 7'd0;
            else
                cnt <= cnt + 7'd1;

            // 50 MHz clock toggles every cycle (period 2)
            // Toggle CLK_50 on every odd count value (when cnt LSB toggles)
            CLK_50 <= ~CLK_50;

            // 10 MHz clock toggles every 5 cycles (period 10)
            // Toggle CLK_10 when counter hits 4 or 9, i.e., half periods
            if (cnt == 7'd4 || cnt == 7'd9 || cnt == 7'd14 || cnt == 7'd19 || cnt == 7'd24 || 
                cnt == 7'd29 || cnt == 7'd34 || cnt == 7'd39 || cnt == 7'd44 || cnt == 7'd49 ||
                cnt == 7'd54 || cnt == 7'd59 || cnt == 7'd64 || cnt == 7'd69 || cnt == 7'd74 ||
                cnt == 7'd79 || cnt == 7'd84 || cnt == 7'd89 || cnt == 7'd94 || cnt == 7'd99)
                CLK_10 <= ~CLK_10;

            // 1 MHz clock toggles every 50 cycles (period 100)
            // Toggle CLK_1 when counter hits 49 and 99 (half period points)
            if (cnt == 7'd49 || cnt == 7'd99)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule