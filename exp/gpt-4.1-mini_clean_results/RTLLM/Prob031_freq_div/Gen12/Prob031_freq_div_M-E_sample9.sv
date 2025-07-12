module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] counter; // Counts 0 to 99 for 100 MHz input clock

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Counter increments modulo 100
            if (counter == 7'd99)
                counter <= 7'd0;
            else
                counter <= counter + 1'b1;

            // CLK_50 toggles every 1 count (divide by 2)
            // Toggle at count 0 and 50 to get 50% duty cycle
            if (counter == 7'd0 || counter == 7'd50)
                CLK_50 <= ~CLK_50;

            // CLK_10 toggles every 5 counts (divide by 10)
            // Toggle at counts 0, 10, 20, 30, 40, 50, 60, 70, 80, 90
            if ( (counter % 7'd10) == 7'd0 )
                CLK_10 <= ~CLK_10;

            // CLK_1 toggles every 50 counts (divide by 100)
            // Toggle at count 0 and 50 for 50% duty cycle
            if (counter == 7'd0 || counter == 7'd50)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule