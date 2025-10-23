module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] counter; // 0 to 99 for 100 cycles

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            if (counter == 7'd99)
                counter <= 7'd0;
            else
                counter <= counter + 7'd1;

            // Toggle CLK_50 at counts 0 and 50 -> frequency division by 2
            if (counter == 7'd0 || counter == 7'd50)
                CLK_50 <= ~CLK_50;

            // Toggle CLK_10 every 5 counts: at counts 0,5,10,...,95
            if (counter % 7'd5 == 7'd0)
                CLK_10 <= ~CLK_10;

            // Toggle CLK_1 at count 49 -> frequency division by 100
            if (counter == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule