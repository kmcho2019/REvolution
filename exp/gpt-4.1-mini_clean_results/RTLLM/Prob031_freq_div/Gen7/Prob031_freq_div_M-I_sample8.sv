module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // 7-bit counter to count from 0 to 99 for 100MHz input clock
    reg [6:0] count;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            count <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Counter increments modulo 100
            if (count == 7'd99)
                count <= 7'd0;
            else
                count <= count + 7'd1;

            // CLK_50 toggles every clock cycle: equal to count bit 0
            CLK_50 <= count[0];

            // CLK_10 toggles every 5 input clocks (divide by 10)
            // Toggle CLK_10 when count is 4 or 9 or 14... i.e., count%10 == 4
            if (count % 10 == 7'd4)
                CLK_10 <= ~CLK_10;

            // CLK_1 toggles every 50 input clocks (divide by 100)
            // Toggle CLK_1 when count == 49
            if (count == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule