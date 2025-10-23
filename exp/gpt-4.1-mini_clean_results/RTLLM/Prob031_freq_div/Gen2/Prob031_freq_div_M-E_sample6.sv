module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    reg [6:0] counter;  // Counts from 0 to 99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Increment counter modulo 100
            if (counter == 7'd99)
                counter <= 7'd0;
            else
                counter <= counter + 7'd1;

            // CLK_50 toggles every cycle (divide by 2)
            // Toggle on counter LSB change (since counter increments every clock)
            // Simplify: toggle every clock cycle
            CLK_50 <= ~CLK_50;

            // CLK_10 toggles at count 4 and 9, i.e., every 5 input clocks (divide by 10)
            if (counter == 7'd4 || counter == 7'd9)
                CLK_10 <= ~CLK_10;

            // CLK_1 toggles at count 49 and 99, i.e., every 50 input clocks (divide by 100)
            if (counter == 7'd49 || counter == 7'd99)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule