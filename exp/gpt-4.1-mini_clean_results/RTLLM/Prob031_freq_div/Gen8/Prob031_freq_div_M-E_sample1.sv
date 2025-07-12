module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] counter;  // count from 0 to 99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // increment counter or reset
            if (counter == 7'd99)
                counter <= 7'd0;
            else
                counter <= counter + 7'd1;

            // CLK_50 toggle every 1 count (half period)
            if (counter == 7'd0)
                CLK_50 <= ~CLK_50;

            // CLK_10 toggle every 5 counts (half period)
            if ((counter == 7'd0) || (counter == 7'd5) || (counter == 7'd10) || (counter == 7'd15) || (counter == 7'd20) ||
                (counter == 7'd25) || (counter == 7'd30) || (counter == 7'd35) || (counter == 7'd40) || (counter == 7'd45) ||
                (counter == 7'd50) || (counter == 7'd55) || (counter == 7'd60) || (counter == 7'd65) || (counter == 7'd70) ||
                (counter == 7'd75) || (counter == 7'd80) || (counter == 7'd85) || (counter == 7'd90) || (counter == 7'd95))
                CLK_10 <= ~CLK_10;

            // CLK_1 toggle every 50 counts (half period)
            if ((counter == 7'd0) || (counter == 7'd50))
                CLK_1 <= ~CLK_1;
        end
    end

endmodule